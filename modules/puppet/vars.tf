#--------------------------------------------------------------
# This module creates the puppet master resources
#--------------------------------------------------------------

#--------------------------------------------------------------
# Puppet Master Variables
#--------------------------------------------------------------
variable "name"          {}
variable "pridomain"        { default = "puppet.vm" }
variable "pubdomain"        { default = "aws.tsedemos.com" }

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
variable "lifetime"      {}
