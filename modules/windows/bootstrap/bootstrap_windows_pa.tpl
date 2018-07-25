<powershell>

$$PEINSTALL_FILE="c:\pe_install.ps1"
$$PEINSTALL_URL="https://${puppet_fqdn}:8140/packages/current/install.ps1"
$$PP_ROLE="${pp_role}"
$$PP_APPLICATION="${pp_application}"
$$PP_ENVIRONMENT="${pp_environment}"
$$CSR_PATH="C:\ProgramData\PuppetLabs\puppet\etc\"
$$CSR_FILE="csr_attributes.yaml"
$$ADMIN_PASSWORD="${password}"

New-Item -Path C:\programdata\puppetlabs\facter\facts.d -ItemType Directory -Force
New-Item -Path C:\ProgramData\PuppetLabs\puppet\etc\ -ItemType Directory -Force

$yaml = @"
---
extension_requests:
  pp_role: ${pp_role}
  pp_environment: ${pp_environment}
  pp_application: ${pp_application}
  pp_hostname: ${name}
  pp_zone: ${domain}
"@

Set-Content -Path C:\ProgramData\PuppetLabs\puppet\etc\csr_attributes.yaml -Content $yaml -Encoding UTF8
"${puppet_ip} ${puppet_name} ${puppet_fqdn}" | Add-Content -Path C:\windows\system32\drivers\etc\hosts

#--------------------------------------------------------------
# Setup Administrator Passwords
#--------------------------------------------------------------
function install_administrator {
  Write-Host "======================= install_administrator ======================="

  $admin = [adsi]("WinNT://./administrator, user")
  $admin.psbase.invoke("SetPassword", $$ADMIN_PASSWORD)

}

#--------------------------------------------------------------
# Wait until PE console is fully operation and install PE
# agent.
#--------------------------------------------------------------
function install_pa {
  Write-Host "======================= Executing install_pa ======================="

  :loop while ($$true) {  
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$$true} 
    $$webclient = New-Object system.net.webclient
    $$webclient.DownloadFile($$PEINSTALL_URL,$$PEINSTALL_FILE)
    if(Test-Path $$PEINSTALL_FILE){
      sleep 300
      Write-Verbose "Starting Installation"
      Invoke-Expression -Command "$$PEINSTALL_FILE main:certname=${name}.${domain}"
      break loop 
    }
    else {
      Write-Verbose "Waiting on PuppetMaster"
	  sleep 30
    }
  }
}

#--------------------------------------------------------------
# Initiate Puppet Run.
#--------------------------------------------------------------
function run_puppet {
  Write-Host "======================= Executing install_pa ======================="
  #puppet agent -t
}

#--------------------------------------------------------------
# Main Script
#--------------------------------------------------------------
install_administrator
install_pa
run_puppet
</powershell>