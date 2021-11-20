
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

resource "aws_instance" "soo_jenky" {
  ami = <the image goes here>
  instance_type "t3.micro" #Nitro system for the win!
  tags = {
    Name = "TommysSyncronExamMess"
  }
}
