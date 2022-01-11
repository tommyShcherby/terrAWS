
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

resource "aws_vpc" "tommys_exam_vpc" {
  cidr_block = "192.168.100.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "TommysExamMess"
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.tommys_exam_vpc.default_network_acl_id
  subnet_ids = [aws_subnet.tommys_exam_subnet.id]

  ingress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = aws_vpc.tommys_exam_vpc.cidr_block
    from_port = 0
    to_port = 0
  }

  egress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.tommys_exam_vpc.id

  ingress {
    protocol = -1 # The provider docs do not have quotes here.
    self = true
    from_port = 0
    to_port = 0
  }

  egress {
    protocol = "-1" # The docs have quotes here.
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
  }
}

resource "aws_subnet" "tommys_exam_subnet" {
  cidr_block = "192.168.100.32/28"
  vpc_id = aws_vpc.tommys_exam_vpc.id
  tags = {
    Name = "TommysExamMess"
  }
}

resource "aws_network_interface" "soo_jenky_interface" {
  subnet_id = aws_subnet.tommys_exam_subnet.id
  security_groups = [aws_security_group.default.id]
  attachment = {
    instance = aws_instance.soo_jenky.id
    device_index = 0 # This might cause an issue if the instance gets another interface automatically.
  }
  tags = {
    Name = "TommysExamMess"
  }
}

data "aws_ami" "standard_al2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "soo_jenky" {
  ami = data.aws_ami.standard_al2.id
  instance_type "t3.micro" #Nitro system for the win!
  tags = {
    Name = "TommysExamMess"
  }
}
