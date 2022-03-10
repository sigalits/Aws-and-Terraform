data "aws_ami" "ubuntu-18" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc"  "vpc" {
   filter {
    name   = "tag:Name"
    values = ["${var.tag_name}-vpc"]
    }
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "Opsschool-sigalits"
    workspaces = {
      name = "sigalits-opschool-vpc"
    }
  }
}



//output "terraform_state" {
//  value = data.terraform_remote_state.vpc
//}
//
//data "aws_subnet"  "public" {
//  filter {
//    name = "vpc-id"
//    values = [data.aws_vpc.vpc.id]
//  }
//  filter {
//    name   = "tag:Name"
//    values = [format("%s-public-*",var.tag_name )]
//  }
//}
//
//data "aws_subnet"  "database" {
//  filter {
//    name = "vpc-id"
//    values = [data.aws_vpc.vpc.id]
//  }
//  filter {
//    name   = "tag:Name"
//    values = [format("%s-database-*",var.tag_name )]
//  }
//}