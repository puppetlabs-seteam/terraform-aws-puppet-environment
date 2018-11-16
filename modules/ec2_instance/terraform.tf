#--------------------------------------------------------------
# Resources: Module Instance Build
#--------------------------------------------------------------
variable "name"           { }
variable "pubdomain"      { }
variable "pridomain"      { }
variable "ami"            { }
variable "subnet_id"      { }
variable "sshkey"         { }
variable "puppet_name"    { default = "puppet" }
variable "puppet_ip"      { }
variable "pp_role"        { }
variable "pp_application" { }
variable "pp_environment" { }
variable "user_name"      { }
variable "instance_type"  { }
variable "count"          { }
variable "zone_id"        { }
variable "puppetize"      { }
variable "ostype"         { }
variable "password"       { default = "none" }


data "template_file" "init" {
    template = "${
      var.ostype == "linux" ? file("modules/ec2_instance/userdata/userdata_linux.tpl") :
      file("modules/ec2_instance/userdata/userdata_windows.tpl")
      }"
    count = "${var.count}"
    vars {
        puppet_name     = "${var.puppet_name}"
        puppet_ip       = "${var.puppet_ip}"
        puppet_fqdn     = "${var.puppet_name}.${var.pridomain}"
        pp_role         = "${var.pp_role}"
        pp_application  = "${var.pp_application}"
        pp_environment  = "${var.pp_environment}"
        name            = "${var.count > 1 ? 
            format("%v-%02d", var.name, count.index + 1) :
            format("%v", var.name)}"
        domain          = "${var.pridomain}"
        puppetize       = "${var.puppetize}"
        password        = "${var.password}"
    }
}

resource "aws_instance" "ec2_instance" {
  ami                         = "${var.ami}"
  count                       = "${var.count}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "true"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.sshkey}"

  tags {
    Name = "${var.count > 1 ? 
            format("%v-%02d.%v", var.name, count.index + 1, var.pridomain) :
            format("%v.%v", var.name, var.pridomain)}"
    department = "tse"
    project = "Demo"
    created_by = "${var.user_name}"
    termination_date = "2020-06-01T19:59:02.539657+00:00"
  }
  user_data = "${element(data.template_file.init.*.rendered, count.index + 1)}"

}

resource "aws_route53_record" "ec2_instance-dns" {
  count = "${var.count}"
  zone_id = "${var.zone_id}"
  name    = "${var.count > 1 ? 
            format("%v-%02d.%v", var.name, count.index + 1, var.pubdomain) :
            format("%v.%v", var.name, var.pubdomain)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.ec2_instance.*.public_ip, count.index)}"]
}
