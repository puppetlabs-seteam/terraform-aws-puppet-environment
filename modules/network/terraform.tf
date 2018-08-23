variable cidr {}
variable pubdomain {}
variable pridomain {}

output "subnet_id" { value = "${aws_subnet.puppetdemos_subnet.id}" }
#--------------------------------------------------------------
# This module creates all site resources
#--------------------------------------------------------------

resource "aws_vpc" "puppetdemos_vpc" {
    cidr_block = "${var.cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
      Name = "${var.pubdomain}-vpc"
      department = "TSE"
      project = "Puppet Demo Environment"
      created_by = "TSE"
      lifetime = "10y"
    }
}

resource "aws_subnet" "puppetdemos_subnet" {
  vpc_id = "${aws_vpc.puppetdemos_vpc.id}"
  cidr_block = "${var.cidr}"
  tags {
      Name = "${var.pubdomain}-subnet"
      department = "TSE"
      project = "Puppet Demo Environment"
      created_by = "TSE"
      lifetime = "10y"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.puppetdemos_vpc.id}"
  tags {
    Name = "${var.pubdomain}-igw"
    department = "TSE"
    project = "Puppet Demo Environment"
    created_by = "TS3"
    lifetime = "10y"
  } 
}

resource "aws_default_network_acl" "defaultnetworkacl" {
  lifecycle {
    ignore_changes = true
  }
  default_network_acl_id = "${aws_vpc.puppetdemos_vpc.default_network_acl_id}"

  egress {
    protocol = "-1"
    rule_no = 2
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  ingress {
    protocol = "-1"
    rule_no = 1
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  tags {
    Name = "${var.pubdomain}-acl"
    department = "TSE"
    project = "Puppet Demo Environment"
    created_by = "TSE"
    lifetime = "10y"
  }
}
resource "aws_default_route_table" "defaultroute" {
  default_route_table_id = "${aws_vpc.puppetdemos_vpc.default_route_table_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "${var.pubdomain}-route"
    department = "TSE"
    project = "Puppet Demo Environment"
    created_by = "TSE"
    lifetime = "10y"
  }
}
resource "aws_default_security_group" "defaultsg" {
  vpc_id = "${aws_vpc.puppetdemos_vpc.id}"

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "4433"
    to_port     = "4433"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = "8081"
    to_port     = "8081"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = "8140"
    to_port     = "8143"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = "3389"
    to_port     = "3389"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = "8170"
    to_port     = "8170"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = "61613"
    to_port     = "61613"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "5985"
    to_port     = "5986"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "8000"
    to_port     = "8000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "7000"
    to_port     = "7000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "2377"
    to_port     = "2377"
    protocol    = "TCP"
    cidr_blocks = ["${var.cidr}"]
  }
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.pubdomain}-sg"
    department = "TSE"
    project = "Puppet Demo Environment"
    created_by = "TSE"
    lifetime = "10y"
  }
  
}

resource "aws_vpc_dhcp_options" "defaultdhcp" {
  domain_name          = "${var.pridomain}"
  domain_name_servers  = [ "AmazonProvidedDNS" ]
  tags {
    Name = "${var.pridomain}-dhcp"
    department = "TSE"
    project = "Puppet Demo Environment"
    created_by = "TSE"
    lifetime = "10y"
  }
}

resource "aws_vpc_dhcp_options_association" "defaultresolver" {
  vpc_id = "${aws_vpc.puppetdemos_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.defaultdhcp.id}"
}