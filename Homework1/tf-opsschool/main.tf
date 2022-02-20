provider "aws" {
  version = "2.25"
  region = var.aws_region
}
#resource "aws_ebs_volume" "vol1" {
#  size = var.ebs_data_size
#  type = var.ebs_data_type
#  encrypted = "true"
#  tags = {
#    name = "${var.tag_name1}-ebs"
#  }
#}
#resource "aws_ebs_volume" "vol2" {
#  size = var.ebs_data_size
#  type = var.ebs_data_type
#  encrypted = "true"
#  tags = {
#    name = "${var.tag_name2}-ebs"
#  }
#}


#Create security group with firewall rules
resource "aws_security_group" "opsschool-ngnix-sg" {
  name        = var.security_group
  description = "security group for ngnix"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "${var.cidr_blocks}"
    description = "Allow nginx"
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.cidr_blocks}"
    description = "Allow ssh "
  }

  ingress {
  cidr_blocks = "${var.cidr_blocks}"
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

  tags= {
    Name = var.security_group
    owner = "sigaliths"
    env = "opsschool"
  }
}

resource "aws_instance" "opsschool_1" {
  ami           = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.opsschool-ngnix-sg.id]
  associate_public_ip_address = "true"
  subnet_id=var.subnet_id
  ebs_block_device {
    device_name           = "xvds"
    volume_type           = var.ebs_data_type
    volume_size           = var.ebs_data_size
    delete_on_termination = true
    encrypted             = true
  }
  user_data = "${file("user_data.sh")}"
  tags= {
    Name = var.tag_name1,
    owner = "sigaliths",
    env = "opsschool",
    operational-hours = "247",
    operational_manager_exclude = "operational_manager_exclude",
    owner-email = "sigaliths@traiana.com",
    application = "Whiskey"
  }
}
resource "aws_instance" "opsschool_2" {
  ami           = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.opsschool-ngnix-sg.id]
  associate_public_ip_address = "true"
  subnet_id=var.subnet_id
  ebs_block_device {
    device_name           = "xvds"
    volume_type           = var.ebs_data_type
    volume_size           = var.ebs_data_size
    delete_on_termination = true
    encrypted             = true
  }
  user_data = "${file("user_data.sh")}"
 tags= {
    Name = var.tag_name2,
    owner = "sigaliths",
    env = "opsschool",
    operational-hours = "247",
    operational_manager_exclude = "operational_manager_exclude",
    owner-email = "sigaliths@traiana.com",
    application = "Whiskey"
  }
}
#resource "aws_volume_attachment" "vol_att1" {
#  device_name = "/dev/sdd"
#  instance_id = "${aws_instance.opsschool_1.id}"
#  volume_id = "${aws_ebs_volume.vol1.id}"
#}
#resource "aws_volume_attachment" "vol_att2" {
#  device_name = "/dev/sdd"
#  instance_id = "${aws_instance.opsschool_2.id}"
#  volume_id = "${aws_ebs_volume.vol2.id}"
#}

output "ec2_public_ip_instance_1" {
  value = "${aws_instance.opsschool_1.*.public_ip}"
}
output "ec2_private_ip_instance_1" {
  value = "${aws_instance.opsschool_1.*.private_ip}"
}

output "ec2_private_ip_instance_2" {
  value = "${aws_instance.opsschool_2.*.private_ip}"
}
output "ec2_public_ip_instance_2" {
  value = "${aws_instance.opsschool_2.*.public_ip}"
}