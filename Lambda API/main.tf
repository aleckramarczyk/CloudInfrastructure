terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
    profile = default
    region = "${var.aws_region}"
}

resource "aws_s3_bucket" "Lambda-API-Code-Bucket" {
    bucket = ""
}