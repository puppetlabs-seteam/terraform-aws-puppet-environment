#--------------------------------------------------------------
# Resources: Module Instance Build
#--------------------------------------------------------------
variable "name"           {}
variable "domain"         {}
variable "ami"            {}
variable "subnet_id"      {}
variable "sshkey"         {}
variable "puppet_name"    {}
variable "puppet_ip"      {}
variable "pp_role"        {}
variable "pp_application" {}
variable "pp_environment" {}
variable "user_name"      {}
variable "instance_type"  {}
variable "lifetime"       {}
variable "zone_id"        {}
variable "puppetize"      {}

data "template_file" "init" {
    template = "${file("modules/ec2_single/userdata/userdata_linux.tpl")}"
    vars {
        puppet_name     = "${var.puppet_name}"
        puppet_ip       = "${var.puppet_ip}"
        puppet_fqdn     = "${var.puppet_name}.${var.domain}"
        pp_role         = "${var.pp_role}"
        pp_application  = "${var.pp_application}"
        pp_environment  = "${var.pp_environment}"
        name            = "${var.name}"
        domain          = "${var.domain}"
        puppetize       = "${var.puppetize}"
    }
}

resource "aws_instance" "ec2_single" {

  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "true"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.sshkey}"

  tags {
    Name = "${var.name}.${var.domain}"
    department = "tse"
    project = "Demo"
    created_by = "${var.user_name}"
    termination_date = "2020-06-01T19:59:02.539657+00:00"
  }
  user_data = "${element(data.template_file.init.*.rendered, count.index + 1)}"

}

resource "aws_route53_record" "ec2_single-dns" {
  zone_id = "${var.zone_id}"
  name    = "${var.name}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2_single.public_ip}"]
}
