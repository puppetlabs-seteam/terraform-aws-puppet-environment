// data "aws_vpc" "tsedemos" {
//   tags {
//     Name = "tsedemos-vpc"
//   }
// }

// data "aws_subnet" "puppetdemos" {
//   tags {
//     Name = "puppetdemos-subnet"
//   }
// }

data "aws_route53_zone" "mydomain" {
  name    = "${var.domain}"
}

data "aws_ami" "windows_2016" {
  owners      = ["amazon"]
  most_recent = true
  filter = {
    name = "name"
    values = ["Windows_Server-*-English-Core-Base*"]
  }
}

data "aws_ami" "centos_7" {
  owners      = ["aws-marketplace"]
  most_recent = true
  filter = {
    name = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
}