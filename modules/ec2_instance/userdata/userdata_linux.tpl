#!/bin/bash
#--------------------------------------------------------------
# This scripts bootstraps a linux node by installing a puppet
# agent.
#--------------------------------------------------------------
set -x
echo HOSTNAME=${name} >> /etc/sysconfig/networking
# echo 127.0.0.1 ${name}.${domain} ${name} >> /etc/hosts
echo ${puppet_ip} ${puppet_fqdn} ${puppet_name} >> /etc/hosts


#--------------------------------------------------------------
# Global Variables:
#   - PATH:       PATHs needed for command execution
#   - HOME:       Home Directory of script account
#   - PEINSTALL:  Command to install PE agent
#   - WORKDIR:    TMP directory for script
#   - LOGFILE:    Execution Log for bootstrap on client hosts
#--------------------------------------------------------------
PATH=$PATH:/opt/puppetlabs/bin
HOME=/tmp
PEINSTALL_FILE=/tmp/pe_install.sh
PEINSTALL_URL="https://${puppet_fqdn}:8140/packages/current/install.bash"
WORKDIR="/tmp"
LOGFILE="$${WORKDIR}/bootstrap$$$$.log"
PP_ROLE=${pp_role}
PP_APPLICATION=${pp_application}
PP_ENVIRONMENT=${pp_environment}
PP_HOSTNAME=${name}
PP_ZONE=${domain}
PUPPETIZE=${puppetize}

#--------------------------------------------------------------
# Redirect all stdout and stderr to logfile,
#--------------------------------------------------------------
echo "======================= Executing setup_logging ======================="
cd "$${WORKDIR}" || exit 1
exec > "$${LOGFILE}" 2>&1

#--------------------------------------------------------------
# Peform pre-agent installation tasks.
#--------------------------------------------------------------
function pre_install_pa {
  echo "======================= Executing pre_install_pa ======================="
  if [ ! -d /etc/puppetlabs/puppet ]; then
    mkdir -p /etc/puppetlabs/puppet
    mkdir -p /etc/puppetlabs/facter/facts.d
    echo "role=${pp_role}" > /etc/puppetlabs/facter/facts.d/role.txt
  fi
  cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
extension_requests:
    pp_role: $${PP_ROLE}
    pp_application: $${PP_APPLICATION}
    pp_environment: $${PP_ENVIRONMENT}
    pp_hostname: $${PP_HOSTNAME}
    pp_zone: $${PP_ZONE}
YAML
}

#--------------------------------------------------------------
# Peform post-agent installation tasks.
#--------------------------------------------------------------
function post_install_pa {
  echo "======================= Executing pre_install_pa ======================="
}

#--------------------------------------------------------------
# Wait until PE console is fully operation and install PE
# agent.
#--------------------------------------------------------------
function install_pa {
  echo "======================= Executing install_pa ======================="

  cd /tmp || exit 1
  sleep 300
  while :; do
    curl -k $${PEINSTALL_URL} -o "$${PEINSTALL_FILE}" && break
    sleep 30
  done
  chmod +x "$${PEINSTALL_FILE}"
  "$${PEINSTALL_FILE}" agent:certname=${name}.${domain}
#--------------------------------------------------------------
# Alternative approach for building custom faces from Nate
# McCurdy.  Wait until next round of testing.
#--------------------------------------------------------------
#"$${PEINSTALL_FILE} --puppet-service-ensure stopped extension_requests:pp_role=$${PP_ROLE} extension_requests:pp_application=$${PP_APPLICATION} extension_requests:pp_environment=$${PP_ENVIRONMENT}"
}

#--------------------------------------------------------------
# Initiate Puppet Run.
#--------------------------------------------------------------
function run_puppet {
  echo "======================= Executing install_pa ======================="
  cd / || exit 1
  puppet agent -t
}

#--------------------------------------------------------------
# Main Script
#--------------------------------------------------------------
pre_install_pa
if [ $PUPPETIZE == 1 ];
then
    install_pa
    post_install_pa
    run_puppet
fi
exit 0