locals {
  puppet_master_name = "puppet"
}



#--------------------------------------------------------------
# Module: Build Puppet Master Server
#--------------------------------------------------------------
module "puppet" {
  source = "../../modules/puppet"
  name          = "${local.puppet_master_name}"
  subnet_id     = "${var.subnet_id}"
  pridomain     = "${var.domain}"
  pubdomain     = "${var.domain}"
  ami           = "${data.aws_ami.centos_7.image_id}"
  sshkey        = "${var.aws_sshkey}"
  git_pri_key   = "${var.git_pri_key}"
  git_pub_key   = "${var.git_pub_key}"
  git_url       = "${var.git_url}"
  eyaml_pri_key = "${var.eyaml_pri_key}"
  eyaml_pub_key = "${var.eyaml_pub_key}"
  user_name     = "${var.user_name}"
  prefix        = "${var.lab_environment}"
  pe_version    = "${var.pe_version}"
  zone_id       = "${data.aws_route53_zone.mydomain.zone_id}"
  domain        = "${var.domain}"
}


#--------------------------------------------------------------
# Module: Build Windows Server
#--------------------------------------------------------------
module "windows" {
  source         = "../../modules/ec2_instance"
  ostype         = "windows"
  name           = "windows"
  puppet_name    = "${local.puppet_master_name}"
  user_name      = "${var.user_name}"
  instance_type  = "${var.windows_instance_type}"
  count          = "${var.windows_count}"
  domain         = "${format("%v", var.domain)}"
  ami            = "${data.aws_ami.windows_2016.image_id}"
  subnet_id      = "${var.subnet_id}"
  sshkey         = "${var.aws_sshkey}"
  password       = "${var.windows_administrator_password}"
  pp_role        = "${var.pp_role}"
  pp_application = "${var.pp_application}"
  pp_environment = "${var.pp_environment}"
  puppet_ip      = "${module.puppet.puppet_private_ip}"
  zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
  puppetize      = true
  prefix          = "${var.lab_environment}"
  lab_environment = "${var.lab_environment}"

}

module "linux" {
  source = "../../modules/ec2_instance"
  ostype = "linux"
  user_name      = "${var.user_name}"
  instance_type  = "${var.linux_instance_type}"
  count          = "${var.linux_count}"
  name           = "linux"
  domain         = "${format("%v", var.domain)}"
  ami            = "${data.aws_ami.centos_7.image_id}"
  subnet_id      = "${var.subnet_id}"
  sshkey         = "${var.aws_sshkey}"
  puppet_name    = "${local.puppet_master_name}"
  pp_role        = "${var.pp_role}"
  pp_application = "${var.pp_application}"
  pp_environment = "${var.pp_environment}"
  puppet_ip      = "${module.puppet.puppet_private_ip}"
  zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
  puppetize      = true
  prefix        = "${var.lab_environment}"
  lab_environment = "${var.lab_environment}"

}

module "cd4pe" {
  source         = "../../modules/ec2_instance"
  ostype         = "linux"
  user_name      = "${var.user_name}"
  instance_type  = "${var.cd4pe_instance_type}"
  count          = "${var.cd4pe_count}"
  name           = "cd4pe"
  domain         = "${format("%v", var.domain)}"
  ami            = "${data.aws_ami.centos_7.image_id}"
  subnet_id      = "${var.subnet_id}"
  sshkey         = "${var.aws_sshkey}"
  puppet_name    = "${local.puppet_master_name}"
  pp_role        = "${var.cd4pe_role}"
  pp_application = "${var.cd4pe_application}"
  pp_environment = "${var.pp_environment}"
  puppet_ip      = "${module.puppet.puppet_private_ip}"
  zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
  puppetize      = true
  prefix        = "${var.lab_environment}"
  lab_environment = "${var.lab_environment}"
}
