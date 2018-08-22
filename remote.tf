provider "aws" {
  version = "~> 1.3"
  region  = "${var.region}"
  profile = "tsetemp"
}
