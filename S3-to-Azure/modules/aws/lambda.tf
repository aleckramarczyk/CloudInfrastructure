data "aws_iam_policy_document" "lambda_assume_role_policy" {
    statement {
      effect = "Allow"
      actions = ["sts:AssumeRole", "s3:*"]

        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }

        resources = [
            aws_s3_bucket.s3_bucket.arn,
            "${aws_s3_bucket.s3_bucket.arn}/*"
        ]
    }
}

resource "aws_iam_role" "lambda_role" {
    name = "s3-backup-lambda"
    assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy

    tags = {
      "env" = var.env
    }
}

data "archive_file" "python_lambda_package" {
    type = "zip"
    source_file = "${path.module}/lambda_code/lambda.py"
    output_path = "lambda.zip"
}

resource "aws_lambda_function" "backup_lambda_function" {
    function_name = "S3_Backup" 
    filename = "lambda.zip"
    source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
    role = aws_iam_role.lambda_role.arn
    runtime = "python3.11"
    handler = "lambda.lambda_handler"
    timeout = 20

    tags = { 
        "env" = var.env
    }
}
