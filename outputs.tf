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

output "get_api_endpoint" {
    description = "API endpoint that goes after the base URL to get values"
    value       = aws_apigatewayv2_route.pyget_route.route_key
}

output "set_api_endpoint" {
    description = "API endpoint that goes after the base URL to set values"
    value       = aws_apigatewayv2_route.pyset_route.route_key
}
