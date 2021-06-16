resource "aws_elb" "this" {
  name               = "liquibase"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  instances = [aws_instance.this.id]

  tags = merge(
    var.default_tags,
    {}
  )
}
