#!/bin/bash

yum -y --security update

amazon-linux-extras install -y docker
systemctl enable docker.service
systemctl start docker.service
usermod -a -G docker ec2-user

docker run --rm -d -p 80:80 nginx
