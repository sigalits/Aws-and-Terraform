variable "aws_region" {
       description = "The AWS region to create things in." 
       default     = "eu-west-1" 
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

variable "security_group" { 
    description = "Name of security group" 
    default     = "opsschool-ngnix-sg"
}

variable "tag_name1" {
    description = "Tag Name of for Ec2 instance" 
    default     = "opschool_instance_1"
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
  type = list
  default = ["10.1.10.0/23","10.1.2.0/23","10.164.0.0/16","192.168.20.0/24","10.165.0.0/18",
      "10.126.0.0/20","172.16.0.0/16","172.16.0.0/16","10.100.8.0/22","10.1.0.0/23","62.219.143.165/32"]
}
