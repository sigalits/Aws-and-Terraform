variable "vpc_cidr" {
  description = "cidr range"
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "database_subnets" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    owner = "sigaliths"
    env = "opsschool"
    owner-email = "sigaliths@traiana.com"
    application = "Whiskey"
  }
}

variable "public_subnet_tags" {
  description = "To find subnets for lb"
  type = map(string)
  default = {
    description = "Public Subnet opsschool"
  }
}

variable "lambda_tags" {
  description = "A map of tags avoid lambda"
  type        = map(string)
  default     = {
     operational-hours = "247"
    operational_manager_exclude = "operational_manager_exclude"
  }

}


variable "aws_region" {
       description = "The AWS region to create things in."
       default     = "eu-west-1"
}

variable "instance_count" {
       description = "Number of instances."
       default     = 2
}

variable "key_name" {
    description = " SSH keys to connect to ec2 instance"
    default     = "sigaliths-main"
}

variable "vpc_id" {
    description = "vpc_id"
    default     = "vpc-0e9d86d829b96c410"
}

variable "subnet_id" {
    description = "subnet_id"
    default     = "subnet-089d3f6bd6ab133a4"
}

variable "instance_type" {
    description = "instance type for ec2"
    default     =  "t3.micro"
}

variable "security_group_ngnix" {
    description = "Name of security group"
    default     = "opsschool-ngnix-sg"
}
variable "security_group_alb" {
    description = "Name of security group"
    default     = "opsschool-alb-sg"
}

variable "security_group_database" {
    description = "Name of security group"
    default     = "opsschool-database-sg"
}
variable "tag_name1" {
    description = "Tag Name of for Ec2 instance"
    default     = "opschool_instance_1"
}
variable "tag_name" {
    description = "Tag Name of for Ec2 instance"
    default     = "opschool"
}
variable "tag_name2" {
    description = "Tag Name of for Ec2 instance"
    default     = "opschool_instance_2"
}
variable "ami_id" {
    description = "AMI for linux centos 7"
    default     = "ami-0000bebe516f304b1"
}
variable "ebs_data_type" {
  description = "ebs_data_type"
  default     = "gp2"
}

variable "ebs_data_size" {
  description = "ebs_data_size"
  default     = 10
}

variable "cidr_blocks" {
  description = "cidr block allow connections"
  type = list(string)
  default = ["10.1.10.0/23","10.1.2.0/23","10.1.0.0/23","10.164.0.0/16","192.168.20.0/24","10.165.0.0/18",
      "10.126.0.0/20","172.16.0.0/16","10.100.8.0/22","192.168.0.0/16","62.219.143.165/32"]
}

