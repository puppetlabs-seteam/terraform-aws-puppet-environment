#--------------------------------------------------------------
# This module creates all demonstration resources
#--------------------------------------------------------------
module "network" {
  source    = "modules/network"
  cidr      = "${var.network}"
  pridomain = "${var.pridomain}"
  pubdomain = "${var.pubdomain}"
}

#--------------------------------------------------------------
# Module: Build Puppet Master Server
#--------------------------------------------------------------
module "puppet" {
  source = "modules/puppet"
  name          = "puppet"
  subnet_id     = "${module.network.subnet_id}"
  pridomain     = "${var.pridomain}"
  pubdomain     = "${var.pubdomain}"
  ami           = "${data.aws_ami.centos_7.image_id}"
  sshkey        = "${var.aws_sshkey}"
  git_pri_key   = "${var.git_pri_key}"
  git_pub_key   = "${var.git_pub_key}"
  git_url       = "${var.git_url}"
  eyaml_pri_key = "${var.eyaml_pri_key}"
  eyaml_pub_key = "${var.eyaml_pub_key}"
  user_name     = "${var.user_name}"
  prefix        = "${var.prefix}"
  pe_version    = "${var.pe_version}"
  zone_id       = "${data.aws_route53_zone.mydomain.zone_id}"
}


#--------------------------------------------------------------
# Module: Build Windows Server
#--------------------------------------------------------------
module "windows" {
  source         = "modules/ec2_instance"
  ostype         = "windows"
  name           = "windows"
  puppet_name    = "puppet"
  user_name      = "${var.user_name}"
  instance_type  = "${var.windows_instance_type}"
  count          = "${var.windows_count}"
  pridomain      = "${var.pridomain}"
  pubdomain      = "${var.pubdomain}"
  ami            = "${var.windows_ami}"
  subnet_id      = "${module.network.subnet_id}"
  sshkey         = "${var.aws_sshkey}"
  password       = "${var.windows_administrator_password}"
  pp_role        = "${var.pp_role}"
  pp_application = "${var.pp_application}"
  pp_environment = "${var.pp_environment}"
  puppet_ip      = "${module.puppet.puppet_private_ip}"
  zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
  puppetize      = true
}

module "linux" {
  source = "modules/ec2_instance"
  ostype = "linux"
  user_name      = "${var.user_name}"
  instance_type  = "${var.linux_instance_type}"
  count          = "${var.linux_count}"
  name           = "linux"
  pridomain      = "${var.pridomain}"
  pubdomain      = "${var.pubdomain}"
  ami            = "${data.aws_ami.centos_7.image_id}"
  subnet_id      = "${module.network.subnet_id}"
  sshkey         = "${var.aws_sshkey}"
  puppet_name    = "puppet"
  pp_role        = "${var.pp_role}"
  pp_application = "${var.pp_application}"
  pp_environment = "${var.pp_environment}"
  puppet_ip      = "${module.puppet.puppet_private_ip}"
  zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
  puppetize      = true
}

module "unmanaged_linux_nodes" {
  source = "modules/ec2_instance"
  ostype         = "linux"
  count          = "${var.unmanaged_linux_count}"
  user_name      = "${var.user_name}"
  instance_type  = "${var.linux_instance_type}"
  name           = "no-lin"
  pridomain      = "${var.pridomain}"
  pubdomain      = "${var.pubdomain}"
  ami            = "${data.aws_ami.centos_7.image_id}"
  subnet_id      = "${module.network.subnet_id}"
  sshkey         = "${var.aws_sshkey}"
  puppet_name    = "puppet"
  pp_role        = "${var.pp_role}"
  pp_application = "${var.pp_application}"
  pp_environment = "${var.pp_environment}"
  puppet_ip      = "${module.puppet.puppet_private_ip}"
  zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
  puppetize      = false
}

module "unmanaged_windows_nodes" {
  source = "modules/ec2_instance"
  ostype         = "windows"
  count          = "${var.unmanaged_windows_count}"
  user_name      = "${var.user_name}"
  instance_type  = "${var.windows_instance_type}"
  name           = "no-win"
  pridomain      = "${var.pridomain}"
  pubdomain      = "${var.pubdomain}"
  ami            = "${data.aws_ami.centos_7.image_id}"
  subnet_id      = "${module.network.subnet_id}"
  sshkey         = "${var.aws_sshkey}"
  puppet_name    = "puppet"
  password       = "${var.windows_administrator_password}"
  pp_role        = "${var.pp_role}"
  pp_application = "${var.pp_application}"
  pp_environment = "${var.pp_environment}"
  puppet_ip      = "${module.puppet.puppet_private_ip}"
  zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
  puppetize      = false
}

#module "cd4pe" {
#  source         = "modules/ec2_instance"
#  ostype         = "linux"
#  user_name      = "${var.user_name}"
#  instance_type  = "${var.cd4pe_instance_type}"
#  count          = "${var.cd4pe_count}"
#  name           = "cd4pe"
#  pridomain      = "${var.pridomain}"
#  pubdomain      = "${var.pubdomain}"
#  ami            = "${data.aws_ami.centos_7.image_id}"
#  subnet_id      = "${module.network.subnet_id}"
#  sshkey         = "${var.aws_sshkey}"
#  puppet_name    = "puppet"
#  pp_role        = "${var.cd4pe_role}"
#  pp_application = "${var.cd4pe_application}"
#  pp_environment = "${var.pp_environment}"
#  puppet_ip      = "${module.puppet.puppet_private_ip}"
#  zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
#  puppetize      = true
#}
#
#// module "discovery" {
#//   source         = "modules/ec2_instance"
#//   ostype         = "linux"
#//   user_name      = "${var.user_name}"
#//   instance_type  = "${var.discovery_instance_type}"
#//   count          = "${var.discovery_count}"
#//   name           = "discovery"
#//   pridomain      = "${var.pridomain}"
#//   pubdomain      = "${var.pubdomain}"
#//   ami            = "${data.aws_ami.centos_7.image_id}"
#//   subnet_id      = "${module.network.subnet_id}"
#//   sshkey         = "${var.aws_sshkey}"
#//   puppet_name    = "puppet"
#//   pp_role        = "${var.discovery_role}"
#//   pp_application = "${var.discovery_application}"
#//   pp_environment = "${var.pp_environment}"
#//   puppet_ip      = "${module.puppet.puppet_private_ip}"
#//   zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
#//   puppetize      = true
#// }
#
#module "pipelines" {
#  source         = "modules/ec2_instance"
#  ostype         = "linux"
#  user_name      = "${var.user_name}"
#  instance_type  = "${var.pipelines_instance_type}"
#  count          = "${var.pipelines_count}"
#  name           = "pipelines"
#  pridomain      = "${var.pridomain}"
#  pubdomain      = "${var.pubdomain}"
#  ami            = "${data.aws_ami.centos_7.image_id}"
#  subnet_id      = "${module.network.subnet_id}"
#  sshkey         = "${var.aws_sshkey}"
#  puppet_name    = "puppet"
#  pp_role        = "${var.pipelines_role}"
#  pp_application = "${var.pipelines_application}"
#  pp_environment = "${var.pp_environment}"
#  puppet_ip      = "${module.puppet.puppet_private_ip}"
#  zone_id        = "${data.aws_route53_zone.mydomain.zone_id}"
#  puppetize      = true
#}
