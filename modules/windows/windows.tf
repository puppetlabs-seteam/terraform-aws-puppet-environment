#--------------------------------------------------------------
# This module creates the win server resources
#--------------------------------------------------------------

#--------------------------------------------------------------
# Resources: Build win Configuration
#--------------------------------------------------------------

data "template_file" "init" {
    template = "${file("modules/windows/bootstrap/bootstrap_windows_pa.tpl")}"
    count = "${var.count}"
    vars {
        puppet_name     = "${var.puppet_name}"
        puppet_ip       = "${var.puppet_ip}"
        puppet_fqdn     = "${var.puppet_name}.${var.domain}"
        password        = "${var.password}"
        pp_role         = "${var.pp_role}"
        pp_application  = "${var.pp_application}"
        pp_environment  = "${var.pp_environment}"
        name            = "${format("${var.name}-%02d", count.index + 1)}"
        domain          = "${var.domain}"
    }
}

resource "aws_instance" "w2016" {


  connection {
    type     = "winrm"
    user     = "Administrator"
    password = "${var.password}"
    # set from default of 5m to 10m to avoid winrm timeout
    timeout  = "10m"
  }
  
  ami                         = "${var.ami}"
  count                       = "${var.count}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "true"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.sshkey}"

  tags {
    Name = "${var.name}-${format("%02d", count.index + 1)}.${var.domain}"
    department = "tse"
    project = "Demo"
    created_by = "${var.user_name}"
    termination_date = "2020-06-01T19:59:02.539657+00:00"
  }
  user_data = "${element(data.template_file.init.*.rendered, count.index + 1)}"
}
