variable "aws_region" {
  description = "The AWS region to which the infrastructure is deployed"
  default     = "eu-central-1"
}

variable "vpc_id" {
  description = "The VPC to which the resources will be associated"
}
