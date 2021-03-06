variable "vpc_cidr" {
 type    = string
}

variable "public_subnets" {
  type    = list(string)
}

variable "database_subnets" {
  type = list(string)
}

variable "tag_name" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "aws_region" {
       description = "The AWS region to create things in."
}


variable "cidr_blocks" {
  description = "cidr block allow connections"
  type = list(string)
 }

