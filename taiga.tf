variable "region" {}
variable "ami" {}
variable "ssh_key" {}
variable "route53_zone" {}
variable "database_id" {}
variable "database_user" {}
variable "database_pw" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "taiga" {
  name = "taiga"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "taiga"
  }
}

resource "aws_instance" "taiga" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${var.ssh_key}"
  security_groups = ["taiga"]

  tags = {
    Name = "taiga"
  }
}

resource "aws_security_group" "taiga_rds_sg" {
  name = "rds_sg"
  depends_on = ["aws_security_group.taiga"]
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.taiga.id}"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "taiga-db" {
  identifier             = "${var.database_id}"
  name                   = "taiga"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "9.4.5"
  instance_class         = "db.t2.micro"
  username               = "${var.database_user}"
  password               = "${var.database_pw}"
  multi_az               = false
  vpc_security_group_ids = ["${aws_security_group.taiga_rds_sg.id}"]
}

resource "aws_route53_record" "taiga" {
  zone_id = "${var.route53_zone}"
  name = "taiga"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.taiga.public_ip}"]
}
