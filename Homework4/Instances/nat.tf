###NAT Gateway###

resource "aws_eip" "nat" {
  count = length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id)
  vpc = true
  tags = {
    "Name" = format(  "%s-%s", var.tag_name, local.azs[count.index] )
  }
}

resource "aws_nat_gateway" "natgw" {
  count = length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id)


  allocation_id = aws_eip.nat[count.index].id
  subnet_id =data.terraform_remote_state.vpc.outputs.database_subnets[count.index].id

  tags = {
      "Name" = format(
        "%s-%s",
        var.tag_name,
        local.azs[count.index])
    }

 }

resource "aws_route_table" "database" {
  count = length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id)
  vpc_id = data.aws_vpc.vpc.id
  tags =  {
      "Name" = "${var.tag_name}-database-${count.index}"
    }
}


resource "aws_route" "database_nat_gateway" {
  count = length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id)
  route_table_id         = aws_route_table.database[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.natgw.*.id, count.index)

  timeouts {
    create = "5m"
  }
}
resource "aws_route_table_association" "nat_gateway" {
  count = length(data.terraform_remote_state.vpc.outputs.database_subnets[*].id)
  subnet_id = data.terraform_remote_state.vpc.outputs.database_subnets[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}