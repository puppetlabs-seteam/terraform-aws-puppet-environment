#--------------------------------------------------------------
# Global Variables
#--------------------------------------------------------------
// variable aws_access_key     {}
// variable aws_secret_key     {}
# Set the Environment Lifetime
# 1h, 1d, 1w, 1y
variable linux_count { default = "1" }
variable windows_count { default = "1" }
variable lifetime  { default = "1w" }
variable aws_sshkey         { default = "puppetdemos" }
variable user_name        {
    description = "The first part of your puppet.com email address."
}
variable prefix             {
    description = "A short prefix to denote your servers, such as your initials."
}

#--------------------------------------------------------------
# Site Variables
#--------------------------------------------------------------
variable region             { default = "us-west-2" }
// variable network0_cidr      { 
//     description = "The CIDR block for your VPC"
// }
// variable network0_subnet0   { 
//     description = "The CIDR block for your primary subnet"
// }
variable pridomain             { default = "puppet.vm" }
variable pubdomain             { default = "tsedemos.com"}

#--------------------------------------------------------------
# Instance Variables
#--------------------------------------------------------------
variable pp_role        { default = "base" }
variable pp_environment { default = "production" }
variable pp_application { default = "generic" }

#--------------------------------------------------------------
# Puppet Master Provisioning Variables
#--------------------------------------------------------------
variable puppet_ami        { default = "ami-6f68cf0f" }
variable pe_version        { default = "2018.1.2" }
variable git_pri_key       { default = "/app/keys/control-repo" }
variable git_pub_key       { default = "/app/keys/control-repo" }
variable git_url           { 
    description = "The git URL to your control repo. Example: https://github.com/cdrobey/puppet-repo"
}
variable eyaml_pri_key     { default = "/app/keys/private_key.pkcs7.pem" }
variable eyaml_pub_key     { default = "/app/keys/public_key.pkcs7.pem" }

#--------------------------------------------------------------
# Jenkins Server Provisioning Variables
#--------------------------------------------------------------
variable jenkins_ami            { default = "ami-6f68cf0f" }
variable jenkins_pp_role        { default = "jenkins"}
variable jenkins_pp_application { default = "jenkins"}
variable jenkins_pp_environment { default = "production"}

#--------------------------------------------------------------
# LINUX Server Provisioning Variables
#--------------------------------------------------------------
variable linux_name          { default = "linux" }
# variable linux_ami           { }
variable linux_instance_type { default = "t2.micro" }


#--------------------------------------------------------------
# Windows Server Provisioning Variables
#--------------------------------------------------------------
variable windows_ami      { default = "ami-d7a114af" }
variable windows_password { default = "Adm1nistrat0r" }
variable windows_instance_type { default = "t2.small" }

#--------------------------------------------------------------
# CD4PE Provisioning Variables
#--------------------------------------------------------------
variable cd4pe_instance_type { default = "m4.large" }

# TODO: Move AMIs to data resource, ensure latest.

