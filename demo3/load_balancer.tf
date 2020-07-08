data "aws_subnet_ids" "subnets" {
  vpc_id      = var.vpc_id
}

resource "aws_lb" "load_balancer" {
  name               = "demo-3-lb"
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.load_balancer_security_group.id
  ]
  subnets            = data.aws_subnet_ids.subnets.ids
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "demo-3-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_security_group" "load_balancer_security_group" {
  name        = "demo-3-lb-sg"
  description = "Allow incoming HTTP traffic; allow any outgoing traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    description = "Allow any outgoing connections"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
