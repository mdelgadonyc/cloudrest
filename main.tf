provider "aws" {
    region = "us-east-1"
}

resource "aws_dynamodb_table" "pets-dynamodb-table" {
    name                = "Pets"
    billing_mode        = "PROVISIONED"
    read_capacity       = 1
    write_capacity      = 1
    hash_key            = "id"

    attribute {
        name = "id"
        type = "S"
    }
}

# Allow Lambda to assume the role
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Create the policy which allows read and write access to our Pets dynamodb table.
data "aws_iam_policy_document" "policy_data" {
    
        statement {
            sid = "ReadWriteTable"

            actions = [
                "dynamodb:BatchGetItem",
                "dynamodb:GetItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchWriteItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem"
            ]

            resources = ["${aws_dynamodb_table.pets-dynamodb-table.arn}"]
        }
}

resource "aws_iam_policy" "policy" {
    name        = "iam_policy"
    policy      = data.aws_iam_policy_document.policy_data.json
}

resource "aws_iam_role_policy_attachment" "db_attachment" {
    role                = aws_iam_role.db_role.name
    policy_arn          = aws_iam_policy.policy.arn
}

resource "aws_iam_role" "db_role" {
    name                = "db-role"
    assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json

    inline_policy {
        policy = data.aws_iam_policy_document.policy_data.json
    }
}

data "archive_file" "lambda_pycode_plset" {
    type            = "zip"
    source_file     = "${path.module}/petLambda-set.py"
    output_path     = "${path.module}/petLambda-set.py.zip"
}

data "archive_file" "lambda_pycode_plget" {
    type            = "zip"
    source_file     = "${path.module}/petLambda-get.py"
    output_path     = "${path.module}/petLambda-get.py.zip"
}


resource "aws_lambda_function" "lambda_function_set" {
    # If this file is not in the current working directory you will need to include a path.modile in the filename.
    filename            = data.archive_file.lambda_pycode_plset.output_path
    function_name       = "pyfun_set"
    role                = aws_iam_role.db_role.arn
    #handler             = "main.lambda_handler"
    handler             = "petLambda-set.lambda_handler"
    source_code_hash    = data.archive_file.lambda_pycode_plset.output_base64sha256

    runtime             = "python3.8"
    memory_size         = 128
    timeout             = 30

    environment {
        variables = {
            foo = "bar"
        }
    }
}

resource "aws_lambda_function" "lambda_function_get" {
    # If this file is not in the current working directory you will need to include a path.modile in the filename.
    filename            = data.archive_file.lambda_pycode_plget.output_path
    function_name       = "pyfun_get"
    role                = aws_iam_role.db_role.arn
    handler             = "petLambda-get.lambda_handler"

    source_code_hash    = data.archive_file.lambda_pycode_plget.output_base64sha256

    runtime             = "python3.8"
    memory_size         = 128
    timeout             = 30

    environment {
        variables = {
            foo = "bar"
        }
    }
}

# Deploy Serverless Applications with AWS Lambda and API Gateway
# https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway

resource "aws_apigatewayv2_api" "api_pyset" {
    name                = "pyset-lambda-pyset-gw"
    protocol_type       = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_pyset" {
    api_id = aws_apigatewayv2_api.api_pyset.id
    
    name        = "pyset-lambda-stage"
    auto_deploy = true

    access_log_settings {
        destination_arn = aws_cloudwatch_log_group.api_gw.arn

        format = jsonencode({
            requestId               = "$context.requestId"
            sourceIp                = "$context.identity.sourceIp"
            requestTime             = "$context.requestTime"
            protocol                = "$context.protocol"
            httpMethod              = "$context.httpMethod"
            resourcePath            = "$context.resourcePath"
            routeKey                = "$context.routeKey"
            status                  = "$context.status"
            responseLength          = "$context.responseLength"
            integrationErrorMessage = "$context.integrationErrorMessage"
        })
    }
}

resource "aws_apigatewayv2_integration" "pyset_integration" {
    api_id = aws_apigatewayv2_api.api_pyset.id

    integration_uri         = aws_lambda_function.lambda_function_set.invoke_arn
    integration_type        = "AWS_PROXY"
    integration_method      = "POST"

}

resource "aws_apigatewayv2_route" "pyset_route" {
    api_id = aws_apigatewayv2_api.api_pyset.id

    route_key = "POST /pet"
    target    = "integrations/${aws_apigatewayv2_integration.pyset_integration.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
    name = "/aws/api-gw/${aws_apigatewayv2_api.api_pyset.name}"

    retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
    statement_id    = "AllowExecutionFromAPIGateway"
    action          = "lambda:InvokeFunction"
    function_name   = aws_lambda_function.lambda_function_set.function_name
    principal       = "apigateway.amazonaws.com"

    source_arn      = "${aws_apigatewayv2_api.api_pyset.execution_arn}/*/*"
}

# possible API Gateway permission issue
# https://repost.aws/knowledge-center/api-gateway-lambda-stage-variable-500
#
# $ curl https://mbxwzgfvd6.execute-api.us-east-1.amazonaws.com/pyget-lambda-stage/pet
# {"message":"Internal Server Error"}
