#--------------------------------------------------------------
# This module creates the win server resources
#--------------------------------------------------------------

#--------------------------------------------------------------
# win Variables
#--------------------------------------------------------------
variable "name"           {}
variable "pubdomain"      {}
variable "pridomain"      {}
variable "ami"            {}
variable "subnet_id"      {}
variable "sshkey"         {}
variable "puppet_name"    {}
variable "password"       {}
variable "pp_role"        {}
variable "pp_application" {}
variable "pp_environment" {}
variable "prefix"         {}
variable "user_name"      {}
variable "puppet_ip"      {}
variable "lifetime"       {}
variable "count"          {}
variable "instance_type"  {}