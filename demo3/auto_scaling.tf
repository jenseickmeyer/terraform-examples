resource "aws_autoscaling_group" "auto_scaling" {
  name = "demo-3-asg"

  min_size = 2
  max_size = 4
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = data.aws_subnet_ids.subnets.ids

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.web_target_group.arn
  ]
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = "demo-3-launch-template"
  instance_type = "t3.nano"
  image_id      = data.aws_ami.amazon_linux_ami.id

  user_data = filebase64("user_data.sh")

  vpc_security_group_ids = [
    aws_security_group.web_server_security_group.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Demo 3 Instance"
    }
  }
}

# Get the most recent version of the Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [ "amzn2-ami-hvm-*-x86_64-gp2" ]
  }

  filter {
    name   = "virtualization-type"
    values = [ "hvm" ]
  }

  owners = [ "amazon" ]
}

resource "aws_security_group" "web_server_security_group" {
  name        = "demo-3-web-sg"
  description = "Allow incoming traffic for SSH and HTTP; allow any outgoing traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from load balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
      aws_security_group.load_balancer_security_group.id
    ]
  }

  egress {
    description = "Allow any outgoing connections"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
