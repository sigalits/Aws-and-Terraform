output "ngnix_public_ips" {
  value = aws_instance.this[*].public_ip
}

output "ngnix_private_ips" {
  value = aws_instance.this[*].private_ip
}

output "ngnix_sg_id" {
  value =var.security_group_ngnix
}

output "ngnix_ids" {
  value = aws_instance.this[*].id
}

output  "web_server" {
  value = aws_instance.this
}