resource "aws_lambda_function" "lambda_api" {
    s3_bucket = aws_s3_bucket.lambda_api_code_bucket.bucket
    s3_key = aws_s3_object.lambda_function_s3_object.key
    function_name = "Lamba API"
}

