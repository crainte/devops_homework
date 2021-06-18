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

resource "aws_sns_topic" "notify" {
  name = "notify"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.notify.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = "elb-target-down"
  namespace           = "AWS/ELB"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  datapoints_to_alarm = "1"
  metric_name         = "UnHealthyHostCount"
  period              = 300
  statistic           = "Sum"
  alarm_actions       = [aws_sns_topic.notify.arn]
  ok_actions          = [aws_sns_topic.notify.arn]
  treat_missing_data  = "breaching"
  dimensions = {
    LoadBalancerName = aws_elb.this.name
  }
}
