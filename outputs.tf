output "rendered_policy" {
    value = data.aws_iam_policy_document.policy_data.json
}
