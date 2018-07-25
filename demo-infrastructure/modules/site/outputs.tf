#--------------------------------------------------------------
# This module creates all site resources
#--------------------------------------------------------------

output "subnet_id" {
  value = "${aws_subnet.puppetdemos_subnet.id}"
}
