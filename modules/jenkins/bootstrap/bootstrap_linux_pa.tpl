#!/bin/bash
#--------------------------------------------------------------
# This scripts bootstraps a linux node by installing a puppet
# agent.
#--------------------------------------------------------------
set -x

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
PEINSTALL_URL="https://${puppet_name}:8140/packages/current/install.bash"
WORKDIR="/tmp"
LOGFILE="$${WORKDIR}/bootstrap$$$$.log"
PP_ROLE=${pp_role}
PP_APPLICATION=${pp_application}
PP_ENVIRONMENT=${pp_environment}

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
  fi
  cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
extension_requests:
    pp_role: $${PP_ROLE}
    pp_application: $${PP_APPLICATION}
    pp_environment: $${PP_ENVIRONMENT}
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

  while :; do
    curl -k $${PEINSTALL_URL} -o "$${PEINSTALL_FILE}" && break
    sleep 30
  done
  chmod +x "$${PEINSTALL_FILE}"
  "$${PEINSTALL_FILE}"
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
install_pa
post_install_pa
run_puppet
exit 0