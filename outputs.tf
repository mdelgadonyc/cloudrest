output "rendered_policy" {
    value = data.aws_iam_policy_document.policy_data.json
}

output "lambda_get_function" {
    value = aws_lambda_function.lambda_function_get.function_name
}

output "lambda_set_function" {
    value = aws_lambda_function.lambda_function_set.function_name
}
