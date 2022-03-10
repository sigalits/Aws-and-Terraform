variable "ubuntu_account_number" {
  description = "Ubuntu formal account"
  default = "099720109477"
}
variable "vpc_cidr" {
  description = "cidr range"
  default = "10.0.0.0/17"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "database_subnets" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "aws_region" {
       description = "The AWS region to create things in."
       default     = "us-east-1"
}

variable "ngnix_instance_count" {
       description = "Number of instances."
       default     = 2
}

variable "db_instance_count" {
       description = "Number of instances."
       default     = 2
}


variable "key_name" {
    description = " SSH keys to connect to ec2 instance"
    default     = "sigalits-ops"
}


variable "instance_type" {
    description = "instance type for ec2"
    default     =  "t2.micro"
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

variable "tag_name" {
    description = "Tag Name of for Ec2 instance"
    default     = "opschool"
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
  default = ["0.0.0.0/0", "62.219.143.165/32"]
  #default = ["10.1.10.0/23","10.1.2.0/23","10.1.0.0/23","10.164.0.0/16","192.168.20.0/24","10.165.0.0/18",
  #    "10.126.0.0/20","172.16.0.0/16","10.100.8.0/22","192.168.0.0/16","62.219.143.165/32"]
}

variable "acl_value" {
    default = "private"
}

variable "bucket_name" {
  description = "S3 bucket name for ngnix access.log"
  default = "whiesky-nginx-log"
}