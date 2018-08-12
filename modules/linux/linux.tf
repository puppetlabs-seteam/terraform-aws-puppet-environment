#--------------------------------------------------------------
# Resources: Module Instance Build
#--------------------------------------------------------------

data "template_file" "init" {
  template = "${file("modules/linux/bootstrap/bootstrap_linux_pa.tpl")}"
  count    = "${var.count}"

  vars {
    puppet_name    = "${var.puppet_name}"
    puppet_ip      = "${var.puppet_ip}"
    puppet_fqdn    = "${var.puppet_name}.${var.domain}"
    pp_role        = "${var.pp_role}"
    pp_application = "${var.pp_application}"
    pp_environment = "${var.pp_environment}"
    name           = "${format("${var.name}-%02d", count.index + 1)}"
    domain         = "${var.domain}"
  }
}

data "aws_route53_zone" "linux" {
  name = "${var.domain}"
}

resource "aws_route53_record" "linux" {
  count   = "${var.count}"
  zone_id = "${data.aws_route53_zone.linux.zone_id}"
  name    = "${var.name}-${format("%02d", count.index + 1)}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.linux.*.public_ip, count.index)}"]
}

resource "aws_instance" "linux" {
  ami                         = "${var.ami}"
  count                       = "${var.count}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "true"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.sshkey}"

  tags {
    Name             = "${var.name}-${format("%02d", count.index + 1)}.${var.domain}"
    department       = "tse"
    project          = "Demo"
    created_by       = "${var.user_name}"
    termination_date = "2020-06-01T19:59:02.539657+00:00"
  }

  user_data = "${element(data.template_file.init.*.rendered, count.index + 1)}"
}
