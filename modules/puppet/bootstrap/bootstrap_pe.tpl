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
MASTERNAME=${master_name}
MASTERFQDN=${master_fqdn}
PATH=$${PATH}:/opt/puppetlabs/bin
HOME=/root
WORKDIR="/tmp"
LOGFILE="$${WORKDIR}/bootstrap$$$$.log"
PVER=${version}
PFILE="puppet-enterprise-${version}-el-7-x86_64.tar.gz"
PURL="https://s3.amazonaws.com/pe-builds/released/${version}/$${PFILE}"

#--------------------------------------------------------------
# Redirect all stdout and stderr to logfile,
#--------------------------------------------------------------
echo "======================= Executing setup_logging ======================="
cd "$${WORKDIR}"
exec > $${LOGFILE} 2>&1

#--------------------------------------------------------------
# Configure hostname and setup host file.
#--------------------------------------------------------------
function setup_host_name {
  echo "======================= Executing setup_host_name ======================="
  echo HOSTNAME=${master_name} >> /etc/sysconfig/networking
  echo 127.0.0.1 ${master_name} ${master_fqdn} >> /etc/hosts
}

#--------------------------------------------------------------
# Initiate Puppet Run.
#--------------------------------------------------------------
function run_puppet {
  echo "======================= Executing run_puppet ======================="

  cd /
  puppet agent -t
}

#--------------------------------------------------------------
# Peform pre-master installation tasks.
#--------------------------------------------------------------
function pre_install_pe {
  echo "======================= Executing pre_install_pa ======================="

  yum -y install wget pciutils gem
  wget $${PURL}
  tar -xzf $${PFILE} -C /tmp/
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

  cat > /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa << FILE
${git_pri_key}
FILE
  chmod 400 /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa
  chown pe-puppet:pe-puppet /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa


  cat > /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub << FILE
${git_pub_key}
FILE
  chmod 400 /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub
  chown pe-puppet:pe-puppet /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub

    mkdir -p /etc/puppetlabs/puppet/eyaml

  cat > /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem << FILE
${eyaml_pri_key}
FILE
  chmod 400 /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem
  chown pe-puppet:pe-puppet /etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem


  cat > /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem << FILE
${eyaml_pub_key}
FILE
  chmod 400 /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem
  chown pe-puppet:pe-puppet /etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem

  puppetserver gem install hiera-eyaml
  /opt/puppetlabs/puppet/bin/gem install hiera-eyaml

  puppet module install pltraining-rbac
  cat > /tmp/user.pp << FILE
rbac_user { 'deploy':
    ensure       => 'present',
    name         => 'deploy',
    display_name => 'deployment user account',
    email        => '${user_name}@puppet.com',
    password     => 'puppetlabs',
    roles        => [ 'Code Deployers' ],
}
FILE
  puppet apply /tmp/user.pp
  rm /tmp/user.pp
  puppet-access -t $${HOME}/.puppetlabs/token login --lifetime=1y << TEXT
deploy
puppetlabs
TEXT
  echo nodes: 100 > /etc/puppetlabs/license.key

  puppet-code -t $${HOME}/.puppetlabs/token deploy production -w
  mkdir -p /etc/puppetlabs/facter/facts.d
  # echo ng_all_id=`puppet resource node_group 'All Nodes' | grep "id " | cut -d"'" -f2` > /etc/puppetlabs/facter/facts.d/nodegroups.txt
  # echo ng_pe_id=`puppet resource node_group 'PE Infrastructure' | grep "id " | cut -d"'" -f2` >> /etc/puppetlabs/facter/facts.d/nodegroups.txt
  # echo ng_prod_id=`puppet resource node_group 'Production environment' | grep "id " | cut -d"'" -f2` >> /etc/puppetlabs/facter/facts.d/nodegroups.txt
  # puppet agent -t
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
"puppet_enterprise::puppet_master_host": "${master_fqdn}"
"puppet_enterprise::profile::master::code_manager_auto_configure": true
"puppet_enterprise::profile::master::r10k_remote": "${git_url}"
"puppet_enterprise::profile::master::r10k_private_key": "/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa"
FILE
  # TODO: this is so wrong but made it set the certname and install again after failure.
  /tmp/puppet-enterprise-$${PVER}-el-7-x86_64/puppet-enterprise-installer -c /tmp/pe.conf
  puppet config set certname  ${master_fqdn}
  /tmp/puppet-enterprise-$${PVER}-el-7-x86_64/puppet-enterprise-installer -c /tmp/pe.conf
  chown pe-puppet:pe-puppet /etc/puppetlabs/puppetserver/ssh/id-*
}

setup_host_name
pre_install_pe
install_pe
post_install_pe
run_puppet
run_puppet

echo "Completed the Bootstrap of Puppet Enterprise!"
