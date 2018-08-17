#--------------------------------------------------------------
# Resources: Module Instance Build
#--------------------------------------------------------------
data "template_file" "init" {
  template = "${file("modules/jenkins/bootstrap/bootstrap_linux_pa.tpl")}"

  vars {
    puppet_name    = "${var.puppet_name}"
    pp_role        = "${var.pp_role}"
    pp_application = "${var.pp_application}"
    pp_environment = "${var.pp_environment}"
  }
}

data "aws_route53_zone" "jenkins" {
  name = "${var.domain}"
}

resource "aws_route53_record" "jenkins" {
  zone_id = "${data.aws_route53_zone.jenkins.zone_id}"
  name    = "${var.name}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.jenkins.public_ip}"]
}

resource "aws_instance" "jenkins" {
  ami                         = "${var.ami}"
  instance_type               = "t2.small"
  associate_public_ip_address = "true"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.sshkey}"

  tags {
    Name       = "${var.name}"
    department = "tse"
    project    = "Demo"
    created_by = "${var.user_name}"
    lifetime   = "${var.lifetime}"
  }

  user_data = "${data.template_file.init.rendered}"
}
