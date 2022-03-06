output "ngnix_public_ips" {
  value = aws_instance.this[*].public_ip
}

output "ngnix_private_ips" {
  value = aws_instance.this[*].private_ip
}

output "ngnix_sg" {
  value = aws_security_group.opsschool-ngnix-sg.id
}

output "ngnix_ids" {
  value = aws_instance.this[*].id
}

output  "web_server" {
  value = aws_instance.this
}