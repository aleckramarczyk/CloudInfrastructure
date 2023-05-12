data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda_api" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_lambda_function" "lambda_api" {
  function_name = "Lambda_API_Test"
  role          = aws_iam_role.iam_for_lambda_api.arn

  runtime          = "python3.9"
  filename         = "${path.module}/API code/lambda_function.zip"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  handler          = "lambda_function.lambda_handler"
  timeout          = 10
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/API code/lambda_function.py"
  output_path = "${path.module}/API code/lambda_function.zip"
}

#API gateway resources
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "{proxy+}"
  # The special path_part value "{proxy+}" activates proxy behavior, which means that this resource will match any request path. Similarly, the aws_api_gateway_method block uses a http_method of "ANY", which allows any request method to be used. Taken together, this means that all incoming requests will match this resource
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda_api.invoke_arn}"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_api.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}