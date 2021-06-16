resource "aws_security_group" "allow-instance-postgres" {
  name        = "allow-instance-postgres"
  description = "Allow specific instance DB access"
  vpc_id      = aws_default_vpc.default.id
}

resource "aws_security_group_rule" "instance-postgres" {
  security_group_id = aws_security_group.allow-instance-postgres.id
  type              = "ingress"
  description       = "From EC2 instance"
  from_port         = 0
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.this.private_ip}/32"]
}

resource "aws_db_instance" "this" {
  engine              = "postgres"
  instance_class      = "db.t2.micro"
  allocated_storage   = 10
  name                = "liquibase"
  skip_final_snapshot = true
  password            = var.rds_password
  username            = var.rds_username

  vpc_security_group_ids = [aws_security_group.allow-instance-postgres.id]

  tags = merge(
    var.default_tags,
    {}
  )
}
