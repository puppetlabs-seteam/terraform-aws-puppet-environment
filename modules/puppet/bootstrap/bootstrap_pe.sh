#!/bin/bash
#--------------------------------------------------------------
# This scripts bootstraps a linux node by installing a puppet
# master.
#--------------------------------------------------------------
set -x

#--------------------------------------------------------------
# Global Variables:
#   - PATH:       PATHs needed for command execution
#   - HOME:       Home Directory of script account
#   - WORKDIR:    TMP directory for script
#   - LOGFILE:    Execution Log for bootstrap on client hosts
#--------------------------------------------------------------
PATH=${PATH}:/opt/puppetlabs/bin
HOME=/root
WORKDIR="/tmp"
LOGFILE="${WORKDIR}/bootstrap$$.log"
PVER=2018.1.2
PFILE="puppet-enterprise-${PVER}-el-7-x86_64.tar.gz"
PURL="https://s3.amazonaws.com/pe-builds/released/${PVER}/${PFILE}"
GITURL=""

#--------------------------------------------------------------
# Redirect all stdout and stderr to logfile,
#--------------------------------------------------------------
echo "======================= Executing setup_logging ======================="
cd "${WORKDIR}" || exit 1
exec > "${LOGFILE}" 2>&1

#--------------------------------------------------------------
# Initiate Puppet Run.
#--------------------------------------------------------------
function run_puppet {
  echo "======================= Executing run_puppet ======================="

  cd / || exit 1
  puppet agent -t
}

#--------------------------------------------------------------
# Peform pre-master installation tasks.
#--------------------------------------------------------------
function pre_install_pe {
  echo "======================= Executing pre_install_pa ======================="

  yum -y install wget pciutils gem
  wget ${PURL}
  tar -xzf ${PFILE} -C /tmp/
  mkdir -p /etc/puppetlabs/puppet/
  echo "*" > /etc/puppetlabs/puppet/autosign.conf
  cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
extension_requests:
    pp_role:  puppetmaster
YAML
}

#--------------------------------------------------------------
# Peform post-master installation tasks.
#--------------------------------------------------------------
function post_install_pe {
  echo "======================= Executing post_install_pe ======================="

  mkdir -p /etc/puppetlabs/puppetserver/ssh

 # cat > /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa << FILE
#${git_pri_key}
#FILE
 # chmod 400 /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa
  #chown pe-puppet:pe-puppet /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa


  #cat > /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub << FILE
#${git_pub_key}
#FILE
 # chmod 400 /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub
  #chown pe-puppet:pe-puppet /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub


  puppet module install pltraining-rbac
  cat > /tmp/user.pp << FILE
rbac_user { 'deploy':
    ensure       => 'present',
    name         => 'deploy',
    display_name => 'deployment user account',
    email        => '${var.user_name}@puppet.com',
    password     => 'puppetlabs',
    roles        => [ 'Code Deployers' ],
}
FILE
  puppet apply /tmp/user.pp
  rm /tmp/user.pp
  puppet-access -t ${HOME}/.puppetlabs/token login --lifetime=1y << TEXT
deploy
puppetlabs
TEXT

  puppet-code -t ${HOME}/.puppetlabs/token deploy production -w
  puppet agent -t

  #--------------------------------------------------------------
  # Configure and apply the node manager module to complete
  # install of puppet master role.  Assuming you have role
  # role::master defined in your code manager repo.
  #--------------------------------------------------------------
  puppet module install WhatsARanjit-node_manager --version 0.5.0
  puppet apply --exec "include profile::master::node_manager"
#  puppet agent --onetime --no-daemonize --color=false --verbose
}
#--------------------------------------------------------------
# Peform master installation tasks.
#--------------------------------------------------------------
function install_pe {
  echo "======================= Executing install_pe ======================="

  cat > /tmp/pe.conf << FILE
"console_admin_password": "puppetlabs"
"puppet_enterprise::puppet_master_host": "%{::trusted.certname}"
"puppet_enterprise::profile::master::code_manager_auto_configure": true
"puppet_enterprise::profile::master::r10k_remote": "${GITURL}"
"puppet_enterprise::profile::master::r10k_private_key": "/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa"
FILE
  /tmp/puppet-enterprise-${PVER}-el-7-x86_64/puppet-enterprise-installer -c /tmp/pe.conf
  chown pe-puppet:pe-puppet /etc/puppetlabs/puppetserver/ssh/id-*
}

setup_host_name
pre_install_pe
install_pe
post_install_pe
run_puppet

echo "Completed the Bootstrap of Puppet Enterprise!"
