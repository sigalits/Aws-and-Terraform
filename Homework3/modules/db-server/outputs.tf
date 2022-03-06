output "database_servers_ips" {
  value = aws_instance.this[*].private_ip
}
output "database_servers_ids" {
  value = aws_instance.this[*].id
}

output  "db_server" {
  value = aws_instance.this
}