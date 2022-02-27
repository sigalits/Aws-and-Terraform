locals {
  azs = ["${var.aws_region}a", "${var.aws_region}b"]
}


resource "aws_vpc" "vpc" {
  cidr_block       =  var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = "true"   # gives you an internal domain name
  enable_dns_hostnames = "true" # gives you an internal host name
  enable_classiclink = "false"

     tags = merge(
    {
      "Name" = format("%s", "${var.tag_name}-vpc")
    },
    var.tags,
   )
}

################
# Public subnet
################
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = var.public_subnets[count.index]
  availability_zone               = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null
  map_public_ip_on_launch         = true

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-public-%s",var.tag_name,element(local.azs, count.index)) },
     var.public_subnet_tags
  )
}



##################
# Database subnet
##################
resource "aws_subnet" "database" {
  count =  length(var.database_subnets)

  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = var.database_subnets[count.index]
  availability_zone               = length(regexall("^[a-z]{2}-", element(local.azs, count.index))) > 0 ? element(local.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "%s-database-%s",
        var.tag_name,
        element(local.azs, count.index),
      )
    },
    var.tags
  )
}

####INTERNET GATEWAY####
resource "aws_internet_gateway" "gateway" {
   vpc_id = aws_vpc.vpc.id
   tags = merge(
    {
      "Name" = format("%s-vpc", var.tag_name)
    },
    var.tags )
}


resource "aws_route_table" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format("%s-public-%s", var.tag_name,count.index)
    },
    var.tags )
   }



 resource "aws_route" "public_route" {
   route_table_id = aws_vpc.vpc.main_route_table_id
   destination_cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gateway.id

   timeouts {
     create = "5m"
   }
 }

resource "aws_route" "public_internet_gateway_ipv6" {
  count = length(local.azs)
  route_table_id              = aws_vpc.vpc.main_route_table_id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  =  aws_internet_gateway.gateway.id
     timeouts {
     create = "5m"
   }
}

###NAT Gateway###

resource "aws_eip" "nat" {
  count = length(var.database_subnets)
  vpc = true
  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        var.tag_name,
        element(local.azs, count.index),
      )
    },
    var.tags
  )
}

resource "aws_nat_gateway" "natgw" {
  count = length(var.database_subnets)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id =aws_subnet.public[count.index].id

  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        var.tag_name,
        element(local.azs, count.index),
      )
    },
    var.tags
  )

 }

resource "aws_route_table" "database" {
  count = length(var.database_subnets)
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = "${var.tag_name}-database"
    },
    var.tags
  )
}


resource "aws_route" "database_nat_gateway" {
  count = length(var.database_subnets)
  route_table_id         = element(aws_route_table.database.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.natgw.*.id, count.index)

  timeouts {
    create = "5m"
  }
}
resource "aws_route_table_association" "nat_gateway" {
  count = length(var.database_subnets)
  subnet_id = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}

#Create security group for ngnix servers
resource "aws_security_group" "opsschool-ngnix-sg" {
  name        = var.security_group_ngnix
  description = "security group for ngnix"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
    description = "Allow nginx"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow NLB"
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
    description = "Allow ssh "
  }

  ingress {
  cidr_blocks = var.cidr_blocks
  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  description = "Allow ping"
}

 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags=var.tags
}

#Create security group for database servers
resource "aws_security_group" "opsschool-database-sg" {
  name        = var.security_group_database
  description = "security group for databases"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
    description = "Allow postgres port"
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
    description = "Allow ssh "
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow ssh in vpn "
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow ssh in vpn "
  }

  ingress {
  cidr_blocks = var.cidr_blocks
  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  description = "Allow ping"
}
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= var.tags
}


resource "aws_instance" "opsschool1" {
  count=var.instance_count
  ami  = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.opsschool-ngnix-sg.id]
  associate_public_ip_address = "true"
  subnet_id=aws_subnet.public[count.index].id
  ebs_block_device {
    device_name           = "/dev/xvds"
    volume_type           = var.ebs_data_type
    volume_size           = var.ebs_data_size
    delete_on_termination = true
    encrypted             = true
  }
  user_data = file("user_data.sh")
  tags = merge(
    {
      "Name" = format("%s", "${var.tag_name}_ngnix_${count.index}")
    },
    var.tags,
    var.lambda_tags
  )
}

resource "aws_ebs_volume" "vol2" {
  count=length(local.azs)
  size = var.ebs_data_size
  type = var.ebs_data_type
  encrypted = "true"
  tags = {
    name = "${var.tag_name2}-ebs"
  }
  availability_zone = local.azs[count.index]
}

resource "aws_instance" "opsschool2" {
  count=var.instance_count
  ami  = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.opsschool-database-sg.id]
  associate_public_ip_address = "false"
  subnet_id=aws_subnet.database[count.index].id
  user_data = file("user_data_db.sh")
  tags = merge(
    {
      "Name" = format("%s", "${var.tag_name}_database_${count.index}")
    },
    var.tags,
    var.lambda_tags
  )
}
resource "aws_volume_attachment" "ebs_att" {
  count=var.instance_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.vol2[count.index].id
  instance_id = aws_instance.opsschool2[count.index].id
}

resource "aws_lb" "lb" {
  name            = "${var.tag_name}-web"
  subnets         = aws_subnet.public[*].id
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true
  tags = var.tags
}

resource "aws_lb_target_group" "target-group" {
  name = "${var.tag_name}-target-group"
  port = 80
  protocol = "TCP"
  target_type = "instance"
  vpc_id = "${aws_vpc.vpc.id}"
  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }
}


# Create a Listener
resource "aws_lb_listener" "my-nlb-listener" {
  default_action {
    target_group_arn = aws_lb_target_group.target-group.arn
    type = "forward"
  }
  load_balancer_arn = aws_lb.lb.arn
  port = 80
  protocol = "TCP"
}

# restister targset to LB

resource "aws_lb_target_group_attachment" "target_att" {
  count=length(local.azs)
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.opsschool1[count.index].id
  port             = 80
}
locals {
  subnets=[aws_subnet.public.*.id]
}

/*data "aws_network_interface" "netint" {
  count = length(var.public_subnets)

  tags = {
    description = "Public Subnet opsschool"
  }

}

resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = formatlist("%s/32", [for eni in data.aws_network_interface.netint : eni.private_ip])
    description = "Allow connection from NLB"
  }
}*/



output "ec2_private_ip_ngnix_instance" {
  value = aws_instance.opsschool1.*.private_ip
}

output "ec2_public_ip_ngnix_instance" {
  value = aws_instance.opsschool1.*.public_ip
}

output "ec2_private_ip_database_instance" {
  value = aws_instance.opsschool2.*.private_ip
}

output "dns_address" {
  value = aws_lb.lb.dns_name
}