#--------------------------------------------------------------
# This module creates the puppet master resources
#--------------------------------------------------------------

output "puppet_name" {
  value = "${aws_instance.puppet.private_dns}"
}

output "puppet_public_ip" {
  value = "${aws_instance.puppet.public_ip}"
}

output "puppet_private_ip" {
  value = "${aws_instance.puppet.private_ip}"
}