output "puppet_master" { value = "${module.puppet.puppet_public_ip}" }
// output "puppet_master_dns" { value = "${module.puppet.puppet_public_dns}" }

// output "ubuntu-16_04-ami" { value = "${data.aws_ami.ubuntu1604.image_id}" }
// output "centos-7-ami" { value = "${data.aws_ami.centos7.image_id}" }
// output "vpc" { value = "${data.aws_vpc.puppetdemos.vpc_id}" }