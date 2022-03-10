output "ec2_private_ip_ngnix_instance" {
  value = module.web-server.ngnix_private_ips[*]
}

output "ec2_public_ip_ngnix_instance" {
  value = module.web-server.ngnix_public_ips[*]
}

output "ec2_private_ip_database_instance" {
  value = module.database.database_servers_ips[*]
}


output "Used_Availability_Zones" {
  value = local.azs
}