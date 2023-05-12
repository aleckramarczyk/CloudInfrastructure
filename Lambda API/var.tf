variable "aws_region" {
    default = "us-west-1"
}

variable "Lambda_API_Code_Bucket_Name" {
}

variable "lambda_function_s3_object_key" {
    default = "lambda_function.go.zip"
}
