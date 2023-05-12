resource "aws_s3_bucket" "lambda_api_code_bucket" {
    bucket = "${var.Lambda_API_Code_Bucket_Name}"

    tags = {
      Name = "Lambda API code bucket"
      Environment = "Dev"
    }
}

resource "aws_s3_bucket_acl" "lambda_api_code_bucket_acl" {
    bucket = aws_s3_bucket.lambda_api_code_bucket.id
    acl = "private"
}

resource "aws_s3_bucket_public_access_block" "lambda_api_code_bucket_public_access_block" {
    bucket = aws_s3_bucket.lambda_api_code_bucket.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}