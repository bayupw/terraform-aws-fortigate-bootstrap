data "aws_region" "this" {}

variable "aws_iam_role" {
  type        = string
  default     = "bootstrap-FortiGate-S3-role"
  description = "Bootstrap IAM role name"
}

variable "aws_iam_policy" {
  type        = string
  default     = "bootstrap-FortiGate-S3-policy"
  description = "Bootstrap IAM policy"
}

variable "bootstrap_bucket" {
  type        = string
  default     = "bootstrap-fortigate-bucket"
  description = "Bootstrap S3 bucket name"
}