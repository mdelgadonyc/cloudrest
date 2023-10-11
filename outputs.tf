output "lambda_get_function" {
    value = aws_lambda_function.lambda_function_get.function_name
}

output "lambda_set_function" {
    value = aws_lambda_function.lambda_function_set.function_name
}

output "api_get_base_url" {
    description = "Base URL for get API Gateway Stage"
    value       = aws_apigatewayv2_stage.api_py.invoke_url
}

#output "api_set_base_url" {
#    description = "Base URL for get API Gateway Stage"
#
#    value       = aws_apigatewayv2_stage.api_pyset.invoke_url
#}