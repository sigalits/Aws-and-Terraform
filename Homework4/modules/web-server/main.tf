#Create security group for ngnix servers


resource "aws_security_group_rule" "nginx_http_acess" {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    type= "ingress"
    security_group_id = var.security_group_ngnix
    cidr_blocks = var.cidr_blocks
    description = "Allow nginx"
}

resource "aws_security_group_rule" "nlb_http_acess" {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    type= "ingress"
    security_group_id = var.security_group_ngnix
    cidr_blocks = [var.vpc_cidr]
    description = "Allow NLB"
}

resource "aws_security_group_rule" "ngnix_ssh_acess" {
    from_port   = 22
    to_port     = 22
    protocol = "tcp"
    type= "ingress"
    security_group_id = var.security_group_ngnix
    cidr_blocks = var.cidr_blocks
    description = "Allow ssh "
}

resource "aws_security_group_rule" "ngnix_ping" {
    from_port   = 8
    to_port     = 0
    protocol = "icmp"
    type= "ingress"
    security_group_id = var.security_group_ngnix
    cidr_blocks = var.cidr_blocks
    description = "Allow ping "
}

resource "aws_security_group_rule" "ngnix_out" {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    type= "egress"
    security_group_id = var.security_group_ngnix
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow out access "
}
resource "aws_s3_bucket" "logs_bucket" {
    bucket = lower(var.bucket_name)
    acl = var.acl_value
    force_destroy = var.force_destroy

  tags = {"Name" = var.bucket_name}
 }

/*
  IAM Roles - for s3 logs sending
*/
resource "aws_iam_role" "s3_iam_role" {
  name = "${var.tag_name}-ROLE"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_iam_role_policy" {
  name = "${var.tag_name}-POLICY"
  role = aws_iam_role.s3_iam_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::${var.bucket_name}"]
        },
        {
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": ["arn:aws:s3:::${var.bucket_name}/*"]
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "s3_ec2_role" {
  name = "${var.tag_name}-EC2ROLE"
  role = aws_iam_role.s3_iam_role.name
}



resource "aws_instance" "this" {
  count = var.create_webservers ? var.ngnix_instance_count : 0
  ami  = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group_ngnix]
  associate_public_ip_address = "true"
  subnet_id=var.subnet_ids[count.index]
  iam_instance_profile = aws_iam_instance_profile.s3_ec2_role.id
  ebs_block_device {
    device_name           = "/dev/xvds"
    volume_type           = var.ebs_data_type
    volume_size           = var.ebs_data_size
    delete_on_termination = true
    encrypted             = true
  }
  user_data = file("${path.module}/user_data_ngnix.sh")
  tags = { "Name" = "${var.tag_name}_${count.index}"}
}