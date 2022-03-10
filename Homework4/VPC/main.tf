locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.ngnix_instance_count)
}


module "vpc" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  aws_region = var.aws_region
  azs = local.azs
  cidr_blocks = var.cidr_blocks
  database_subnets = var.database_subnets
  public_subnets = var.public_subnets
  tag_name = var.tag_name
}

#Create security group for ngnix servers
resource "aws_security_group" "opsschool-ngnix-sg" {
  name        = var.security_group_ngnix
  description = "security group for ngnix"
  vpc_id = module.vpc.vpc_id
}




