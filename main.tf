# Create 3 digit random string
resource "random_string" "this" {
  length  = 3
  special = false
  upper   = false
}

# Concatenate with random string to avoid duplication
locals {
  aws_iam_role     = "${var.aws_iam_role}-${random_string.this.id}"
  aws_iam_policy   = "${var.aws_iam_policy}-${random_string.this.id}"
  bootstrap_bucket = "${var.bootstrap_bucket}-${data.aws_region.this.name}-${random_string.this.id}"
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

# Create an S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket = local.bootstrap_bucket
  force_destroy = true

  tags = {
    Name = local.bootstrap_bucket
  }
}

# Make S3 Bucket Private
/* resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}*/

# Create S3 ACL
resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

# Upload init.conf to S3
resource "aws_s3_object" "init_conf" {
  bucket = aws_s3_bucket.this.id
  key    = "init.conf"
  source = "./bootstrap/init.conf"
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "this" {
  name = local.aws_iam_role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "this" {
  name        = local.aws_iam_policy
  description = local.aws_iam_policy

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

# Create IAM Instance Profile
# Note: name must be same as IAM role, else firewall instance will throw an error 'No Instance profile found for IAM role name'
resource "aws_iam_instance_profile" "this" {
  name = local.aws_iam_role
  role = aws_iam_role.this.name
}