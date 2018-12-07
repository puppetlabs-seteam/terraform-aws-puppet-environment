
data "aws_route53_zone" "mydomain" {
  name    = "${var.domain}"
}


data "aws_ami" "windows_2016" {
  owners      = ["801119661308"]
  most_recent = true
  filter = {
    name = "name"
    values = ["Windows_Server-2016-English-Full-Base-2018*"]
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