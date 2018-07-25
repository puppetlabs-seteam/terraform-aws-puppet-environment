#--------------------------------------------------------------
# Module: Create Site Infrastructure
#--------------------------------------------------------------

variable "subnet_cidr" {}
variable "vpc_cidr" {}
variable "region" {}

provider "aws" {
  region     = "${var.region}"
}

module "site" {
  source      = "modules/site"
  vpc_cidr    = "${var.vpc_cidr}"
  subnet_cidr = "${var.subnet_cidr}"
}
