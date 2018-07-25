data "aws_vpc" "puppetdemos" {
  tags {
    Name = "puppetdemos-vpc"
  }
}

data "aws_subnet" "puppetdemos" {
  tags {
    Name = "puppetdemos-subnet"
  }
}

data "aws_ami" "ubuntu1604" {
  owners      = ["099720109477"]
  most_recent = true
  filter = {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}

data "aws_ami" "centos7" {
  owners      = ["aws-marketplace"]
  most_recent = true
  filter = {
    name = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
}

