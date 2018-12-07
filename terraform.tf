variable "region" { default = "us-west-2" }
variable "pridomain" {}
variable "pubdomain" {}
variable "prefix" {}

provider "aws" {
  region  = "${var.region}"
  // access_key = "AKIAJZXJSYGOWWOA7ECQ"
  // secret_key = "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"
  access_key = "AKIAIYYTWPA6C6FOVMZQ"
  secret_key = "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"
}
#--------------------------------------------------------------
# This module creates all demonstration resources
#--------------------------------------------------------------
module "network" {
  source    = "modules/network"
  cidr      = "10.0.5.0/24"
  pridomain = "${var.pridomain}"
  pubdomain = "${var.pubdomain}"
  prefix    = "${var.prefix}"
}

module "lab-01" {
  source          = "modules/demo_env"
  lab_environment = "lab-01"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-01.tsedemos.com"
}

module "lab-02" {
  source          = "modules/demo_env"
  lab_environment = "lab-02"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-02.tsedemos.com"

}

module "lab-03" {
  source          = "modules/demo_env"
  lab_environment = "lab-03"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-03.tsedemos.com"

}

module "lab-04" {
  source          = "modules/demo_env"
  lab_environment = "lab-04"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-04.tsedemos.com"

}

module "lab-05" {
  source          = "modules/demo_env"
  lab_environment = "lab-05"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-05.tsedemos.com"

}

module "lab-06" {
  source          = "modules/demo_env"
  lab_environment = "lab-06"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-06.tsedemos.com"

}

module "lab-07" {
  source          = "modules/demo_env"
  lab_environment = "lab-07"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-07.tsedemos.com"

}

module "lab-08" {
  source          = "modules/demo_env"
  lab_environment = "lab-08"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-08.tsedemos.com"

}

module "lab-09" {
  source          = "modules/demo_env"
  lab_environment = "lab-09"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-09.tsedemos.com"

}

module "lab-10" {
  source          = "modules/demo_env"
  lab_environment = "lab-10"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-10.tsedemos.com"

}

module "lab-11" {
  source          = "modules/demo_env"
  lab_environment = "lab-11"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-11.tsedemos.com"

}

module "lab-12" {
  source          = "modules/demo_env"
  lab_environment = "lab-12"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-12.tsedemos.com"

}

module "lab-13" {
  source          = "modules/demo_env"
  lab_environment = "lab-13"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-13.tsedemos.com"

}

module "lab-14" {
  source          = "modules/demo_env"
  lab_environment = "lab-14"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-14.tsedemos.com"

}

module "lab-15" {
  source          = "modules/demo_env"
  lab_environment = "lab-15"
  subnet_id       = "${module.network.subnet_id}"
  domain          = "lab-15.tsedemos.com"

}
// module "lab-02" {
//   source          = "modules/demo_env"
//   lab_environment = "lab-02"
//   subnet_id       = "${module.network.subnet_id}"
// }
