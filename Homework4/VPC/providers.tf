terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.70"
    }
  }
  cloud {
    hostname = "app.terraform.io"
    organization = "Opsschool-sigalits"
    workspaces {
      name = "sigalits-opschool-vpc"
    }
  }
}


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

