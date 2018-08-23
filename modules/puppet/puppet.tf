#--------------------------------------------------------------
# This module creates the puppet master resources
#--------------------------------------------------------------
variable "name"          {}
variable "ami"           {}
variable "subnet_id"     {}
variable "sshkey"        {}
variable "git_pri_key"   {}
variable "git_pub_key"   {}
variable "git_url"       {}
variable "eyaml_pri_key" {}
variable "eyaml_pub_key" {}
variable "prefix"        {}
variable "user_name"     {}
variable "pe_version"    {}
variable "zone_id"       {}
variable "pridomain"     {}
variable "pubdomain"     {}

#--------------------------------------------------------------
# Resources: Build Puppet Master Configuration
#--------------------------------------------------------------
data "template_file" "init" {
    template = "${file("modules/puppet/bootstrap/bootstrap_pe.tpl")}"
    vars {
        master_name   = "${var.name}"
        master_fqdn   = "${var.name}.${var.pridomain}"
        git_pri_key   = "${file("${var.git_pri_key}")}"
        git_pub_key   = "${file("${var.git_pub_key}")}"
        git_url       = "${var.git_url}"
        eyaml_pri_key = "${file("${var.eyaml_pri_key}")}"
        eyaml_pub_key = "${file("${var.eyaml_pub_key}")}"
        user_name     = "${var.user_name}"
        version       = "${var.pe_version}"
    }
}

resource "aws_instance" "puppet" {

  ami                         = "${var.ami}"
  instance_type               = "m4.large"
  associate_public_ip_address = "true"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.sshkey}"

  tags {
    Name = "${var.name}.${var.pridomain}"
    department = "tse"
    project = "Demo"
    created_by = "${var.user_name}"
    termination_date = "2020-06-01T19:59:02.539657+00:00"
  }
  user_data = "${data.template_file.init.rendered}"
}

resource "aws_route53_record" "puppet" {
  zone_id = "${var.zone_id}"
  name    = "puppet.${var.pubdomain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.puppet.public_ip}"]
}