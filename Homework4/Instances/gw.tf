####INTERNET GATEWAY####
resource "aws_internet_gateway" "gateway" {
   vpc_id = data.aws_vpc.vpc.id
   tags = merge(
    {
      "Name" = format("%s-vpc", var.tag_name)
    } )
}


resource "aws_route_table" "public" {
  count = length([data.terraform_remote_state.vpc.outputs.public_subnets[*].id])
  vpc_id = data.aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format("%s-public-%s", var.tag_name,count.index)
    } )
   }



 resource "aws_route" "public_route" {
   route_table_id = data.aws_vpc.vpc.main_route_table_id
   destination_cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gateway.id

   timeouts {
     create = "5m"
   }
 }

resource "aws_route" "public_internet_gateway_ipv6" {
  count = length([data.terraform_remote_state.vpc.outputs.public_subnets[*].id])
  route_table_id              =  data.aws_vpc.vpc.main_route_table_id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  =  aws_internet_gateway.gateway.id
     timeouts {
     create = "5m"
   }
}
