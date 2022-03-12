locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.ngnix_instance_count)
}

module "web-server" {
  source = "../modules/web-server"
  ngnix_instance_count = var.ngnix_instance_count
  ami_id = data.aws_ami.ubuntu-18.id
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets[*].id
  cidr_blocks = var.cidr_blocks
  security_group_ngnix = data.terraform_remote_state.vpc.outputs.ngnix_sg
  vpc_id = data.aws_vpc.vpc.id
  vpc_cidr = var.vpc_cidr
  ebs_data_size = var.ebs_data_size
  ebs_data_type = var.ebs_data_type
  tag_name = format("%s", "${var.tag_name}_ngnix")
  acl_value = var.acl_value
  bucket_name = var.bucket_name
  force_destroy = var.force_destroy
  create_webservers = var.create_webservers
}

module "database" {
  source  = "app.terraform.io/Opsschool-sigalits/dbserver/aws"
  version = "1.1.0"
#  source = "../modules/db-server"
  db_instance_count = var.db_instance_count
  ami_id = data.aws_ami.ubuntu-18.id
  key_name = var.key_name
  instance_type = var.instance_type
  subnet_ids = data.terraform_remote_state.vpc.outputs.database_subnets[*].id
  cidr_blocks = var.cidr_blocks
  az = local.azs
  vpc_id = data.aws_vpc.vpc.id
  vpc_cidr = var.vpc_cidr
  security_group_database = var.security_group_database
  ebs_data_size = var.ebs_data_size
  ebs_data_type = var.ebs_data_type
  tag_name = format("%s", "${var.tag_name}_database")
}






