variable "aws_profile" {
  type    = string
  default = "mily-aws-student"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
