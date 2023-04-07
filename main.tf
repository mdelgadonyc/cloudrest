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