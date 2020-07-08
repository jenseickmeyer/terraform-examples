variable "aws_region" {
  description = "The AWS region to which the infrastructure is deployed"
  default     = "eu-central-1"
}

variable "vpc_id" {
  description = "The VPC to which the resources will be associated"
}

variable "desired_capacity" {
  description = "The number of instances that should be running"
  default     = 2
}
