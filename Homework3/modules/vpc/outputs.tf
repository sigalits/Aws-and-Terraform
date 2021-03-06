output "public_subnets" {
  value = aws_subnet.public
}

output "database_subnets" {
  value = aws_subnet.database
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}


output "main_route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}