
locals {
  azs= slice(data.aws_availability_zones.available.names,0,2)
}


module "vpc" {
  source = "./modules/vpc"
    vpc_cidr       =  var.vpc_cidr
    aws_region = var.aws_region
    azs=local.azs
    cidr_blocks = var.cidr_blocks
    database_subnets = var.database_subnets
    public_subnets = var.public_subnets
  tag_name = var.tag_name
}



module "web-server" {
  source = "./modules/web-server"
  ngnix_instance_count = var.ngnix_instance_count
  ami_id  = data.aws_ami.ubuntu-18.id
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_ids=toset(module.vpc.public_subnets[*].id)
  cidr_blocks = var.cidr_blocks
  security_group_ngnix = var.security_group_ngnix
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  ebs_data_size = var.ebs_data_size
  ebs_data_type = var.ebs_data_type
  tag_name = format("%s", "${var.tag_name}_ngnix")
  acl_value = var.acl_value
  bucket_name = var.bucket_name
}

module "database" {
  source = "./modules/db-server"
  db_instance_count = var.db_instance_count
  ami_id  = data.aws_ami.ubuntu-18.id
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_ids=toset(module.vpc.database_subnets[*].id)
  cidr_blocks = var.cidr_blocks
  az=local.azs
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  security_group_database = var.security_group_database
  ebs_data_size = var.ebs_data_size
  ebs_data_type = var.ebs_data_type
  tag_name = format("%s", "${var.tag_name}_database")
}






