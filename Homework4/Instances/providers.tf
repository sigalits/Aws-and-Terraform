terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70"
    }
  }
  backend = "remote"
  config = {
    organization = "Opsschool-sigalits"
    workspaces = {
      name = "sigalits-opschool-vpc"
    }

}
}
//  backend "s3" {
//  bucket = "opsschool-terraform-bucket"
//  key =  "aws-basics/terraform_instances.tfstate"
//  region  = "us-east-1"
//  }
//  required_version = ">= 0.14.9"




provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      owner = "sigalits"
      env = "opsschool"
      owner-email = "sigalit.hillel@gmail.com"
      application = "Whiskey"
    }
  }
}

