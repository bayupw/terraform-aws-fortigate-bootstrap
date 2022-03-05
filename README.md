# Terraform Fortigate Bootstrap on AWS S3

This repository provides a Terraform implementation to create AWS S3 and relevant IAM roles for bootstrapping Fortigate on AWS.

The code provided is for demo purposes only.

## Prerequisites

Please make sure you have:
- AWS access keys and secrets 

## Environment Variables

To run this project, you will need to set the following environment variables

Variables | Description
--- | ---
AWS_ACCESS_KEY_ID | AWS Access Key
AWS_SECRET_ACCESS_KEY | AWS Secret Access Key
AWS_DEFAULT_REGION | AWS Default Region

## Run Locally

Clone the project

```bash
git clone https://github.com/bayupw/terraform-aws-fortigate-bootstrap.git
```

Go to the project directory

```bash
cd terraform-aws-fortigate-bootstrap
```

Set environment variables

```bash
export AWS_ACCESS_KEY_ID="A1b2C3d4E5"
export AWS_SECRET_ACCESS_KEY="A1b2C3d4E5"
export AWS_DEFAULT_REGION="ap-southeast-2"
```

Terraform workflow

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|----------|
| aws_iam_role | Bootstrap IAM role name | `bootstrap-FortiGate-S3-role` | no |
| aws_iam_policy | Bootstrap IAM policy | `bootstrap-FortiGate-S3-policy` | no |
| bootstrap_bucket | Bootstrap S3 bucket name | `bootstrap-fortigate-bucket` | no |