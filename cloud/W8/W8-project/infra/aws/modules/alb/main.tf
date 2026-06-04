resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Allow inbound HTTP to the application load balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_from_internet" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  description = "HTTP from internet"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound traffic"
}

resource "aws_lb_target_group" "this" {
  name_prefix = "w8tg-"
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    matcher             = "200-399"
    path                = "/health"
    protocol            = "HTTP"
  }

  tags = {
    Name = "${var.name_prefix}-app-tg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_instance_id
  port             = var.target_port
}

resource "aws_lb" "this" {
  name            = substr("${var.name_prefix}-alb", 0, 32)
  security_groups = [aws_security_group.this.id]
  subnets         = var.subnet_ids

  tags = {
    Name = "${var.name_prefix}-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_http_from_alb" {
  security_group_id            = var.target_security_group_id
  referenced_security_group_id = aws_security_group.this.id
  from_port                    = var.target_port
  ip_protocol                  = "tcp"
  to_port                      = var.target_port

  description = "App traffic from ALB"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
