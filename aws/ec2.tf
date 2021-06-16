data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group_rule" "allow-only-elb" {
  security_group_id        = aws_default_security_group.default.id
  type                     = "ingress"
  description              = "Allow traffic from specific elb"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_elb.this.source_security_group_id
}

resource "aws_security_group_rule" "allow-only-rds" {
  security_group_id        = aws_default_security_group.default.id
  type                     = "ingress"
  description              = "Allow traffic from specific rds"
  from_port                = 0
  to_port                  = 0
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.allow-instance-postgres.id
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = merge(
    var.default_tags,
    {}
  )
}
