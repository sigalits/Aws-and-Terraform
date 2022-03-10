variable "vpc_id" {
  description = "Vpc id"
  type = string
}
variable "subnet_ids" {
  description = " subnets id's"
  type = list(string)
}

variable "vpc_cidr" {
  description = "cidr range"
  type = string
}


variable "ngnix_instance_count" {
  description = "Instance servers"
  type = number
}
variable "key_name" {
    description = " SSH keys to connect to ec2 instance"
    type = string
}


variable "instance_type" {
    description = "instance type for ec2"
    type = string
}

variable "bucket_name" {
  description = "S3 backet name for logs"
  type = string
}

variable "acl_value" {
  type = string
}
variable "security_group_ngnix" {
    description = "Name of security group"
    type = string
}

variable "tag_name" {
    description = "Tag Name of for Ec2 instance"
    type = string
}

variable "ami_id" {
    description = "AMI for linux centos 7"
    type = string
}
variable "ebs_data_type" {
  description = "ebs_data_type"
  type = string
}

variable "ebs_data_size" {
  description = "ebs_data_size"
  type = number
}

variable "cidr_blocks" {
  description = "cidr block allow connections"
  type = list(string)
}

