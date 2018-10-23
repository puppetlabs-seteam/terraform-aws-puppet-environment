#--------------------------------------------------------------
# Global Variables
#--------------------------------------------------------------

# COUNTS
# How many of each. For disco/pfa/cd4pe use 0 or 1
variable linux_count { default = 0 }
variable windows_count { default = 0 }
variable pipelines_count { default = 0 }
variable cd4pe_count { default = 0 }
variable discovery_count { default = 0 }
variable unmanaged_linux_count { default = 0 }
variable unmanaged_windows_count { default = 0 }

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
variable region    { default = "us-west-2" }
variable pubdomain { default = "puppet.vm" }
variable pridomain {}
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
variable pe_version        { default = "2018.1.3" }
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
variable windows_administrator_password { default = "Adm1nistrat0r" }
variable windows_instance_type { default = "t2.small" }

#--------------------------------------------------------------
# CD4PE Provisioning Variables
#--------------------------------------------------------------
variable cd4pe_instance_type { default = "m4.large" }

# TODO: Move AMIs to data resource, ensure latest.

variable network {}
variable cd4pe_application { default = "cd4pe" }
variable cd4pe_role { default = "cd4pe" }
variable discovery_application { default = "cd4pe" }
variable discovery_instance_type {default = "cd4pe"}
variable discovery_role { default = "cd4pe" }
variable pipelines_instance_type { default = "cd4pe" }
variable pipelines_application { default = "cd4pe"}
variable pipelines_role {default = "cd4pe"}