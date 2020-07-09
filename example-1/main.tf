provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ec2_instance" {
  instance_type = "t3.nano"
  ami           = data.aws_ami.amazon_linux_ami.id
  key_name      = var.key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [
    aws_security_group.security_group.id
  ]

  user_data = <<-EOF
    #!/bin/bash

    yum -y --security update

    amazon-linux-extras install -y docker
    systemctl enable docker.service
    systemctl start docker.service
    usermod -a -G docker ec2-user

    docker run --rm -d -p 80:80 nginx
  EOF

  tags = {
    Name = "Demo 1 Instance"
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

resource "aws_security_group" "security_group" {
  name        = "demo-1-sg"
  description = "Allow incoming traffic for SSH and HTTP; allow any outgoing traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

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
