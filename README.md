# Terraform Demos
This repository contains the following use cases for *Amazon Web Services* (AWS) implemented with Terraform:

- [Demo 1](demo1): Launch a simple EC2 instance which runs nginx as a Docker container
- [Demo 2](demo2): Launch an *Application Load Balancer* (ALB) and attach an EC2 instance to it
- [Demo 3](demo3): Launch an *Application Load Balancer* (ALB) and attach an Autoscaling Group which is responsible for starting EC2 instances

## Prerequisites
In order to try out the demos you need to install [Terraform](https://www.terraform.io). The demos have been tested with version 0.12.24.

Additionally, you need to have an AWS account and [configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) to access AWS programmatically.

## Deploy the demos
The resources need to be created in a *Virtual Private Cloud* (VPC). Essentially, this is just a private network within the AWS cloud. For each account a default VPC is available. To get the ID of this VPC you can run the following command:

```
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" \
                               --query "Vpcs[0].VpcId" \
                               --output text \
                               --region eu-central-1)
```

In order to run the demos you need to perform the following steps in each directory:

```
export AWS_SDK_LOAD_CONFIG=1

terraform init
terraform apply -var "vpc_id=$VPC_ID"
```

By defaut, the infrastructure is created in the AWS region *Europe (Frankfurt)* (eu-central-1). To change this you can overwrite the variable with the value for a different AWS region:

```
terraform apply -var "vpc_id=$VPC_ID" -var "aws_region=us-east-1"
```

In this case the infrastructure will be created in *US East (N. Virginia)*.

To get the list of all the available regions you can use this AWS CLI command:

```
aws ec2 describe-regions --query "Regions[].RegionName"
```

## Clean up
After you have tried out the demos you can destroy the resources via the following command:

```
terraform destroy -var "vpc_id=$VPC_ID"
```
