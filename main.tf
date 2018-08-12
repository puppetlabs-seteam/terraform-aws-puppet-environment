#--------------------------------------------------------------
# This module creates all demonstration resources
#--------------------------------------------------------------



#--------------------------------------------------------------
# Module: Create Site Infrastructure
#--------------------------------------------------------------
// module "site" {
//   source = "modules/site"

//   network0_cidr    = "${var.network0_cidr}"
//   network0_subnet0 = "${var.network0_subnet0}"
//   domain           = "${var.prefix}-${var.domain}"
//   user_name        = "${var.user_name}"
//   prefix           = "${var.prefix}"
//   lifetime         = "${var.lifetime}"

// }

#--------------------------------------------------------------
# Module: Build Puppet Master Server
#--------------------------------------------------------------
module "puppet" {
  source = "modules/puppet"
  name          = "puppet"
  subnet_id     = "${data.aws_subnet.puppetdemos.id}"
  pridomain     = "${var.prefix}-${var.pridomain}"
  pubdomain     = "${var.prefix}-${var.pubdomain}"
  ami           = "${data.aws_ami.centos7.image_id}"
  sshkey        = "${var.aws_sshkey}"
  git_pri_key   = "${var.git_pri_key}"
  git_pub_key   = "${var.git_pub_key}"
  git_url       = "${var.git_url}"
  eyaml_pri_key = "${var.eyaml_pri_key}"
  eyaml_pub_key = "${var.eyaml_pub_key}"
  user_name     = "${var.user_name}"
  prefix        = "${var.prefix}"
  pe_version    = "${var.pe_version}"
  lifetime      = "${var.lifetime}"
}


#--------------------------------------------------------------
# Module: Build Windows Server
#--------------------------------------------------------------
module "windows" {
  source = "modules/windows"
  user_name      = "${var.user_name}"
  instance_type  = "${var.windows_instance_type}"
  count          = "${var.windows_count}"
  prefix         = "${var.prefix}"
  name           = "windows"
  pridomain      = "${var.prefix}-${var.pridomain}"
  pubdomain      = "${var.prefix}-${var.pubdomain}"
  ami            = "${var.windows_ami}"
  subnet_id      = "${data.aws_subnet.puppetdemos.id}"
  sshkey         = "${var.aws_sshkey}"
  puppet_name    = "puppet"
  password       = "${var.windows_password}"
  pp_role        = "${var.pp_role}"
  pp_application = "${var.pp_application}"
  pp_environment = "${var.pp_environment}"
  puppet_ip      = "${module.puppet.puppet_private_ip}"
  lifetime       = "${var.lifetime}"
}

module "linux" {
  source = "modules/linux"
  user_name      = "${var.user_name}"
  instance_type  = "${var.linux_instance_type}"
  prefix         = "${var.prefix}"
  name           = "linux"
  count          = "${var.linux_count}"
  pridomain      = "${var.prefix}-${var.pridomain}"
  pubdomain      = "${var.prefix}-${var.pubdomain}"
  ami            = "${data.aws_ami.centos7.image_id}"
  subnet_id      = "${data.aws_subnet.puppetdemos.id}"
  sshkey         = "${var.aws_sshkey}"
  puppet_name    = "puppet"
  pp_role        = "${var.pp_role}"
  pp_application = "${var.pp_application}"
  pp_environment = "${var.pp_environment}"
  puppet_ip      = "${module.puppet.puppet_private_ip}"
  lifetime       = "${var.lifetime}"
}