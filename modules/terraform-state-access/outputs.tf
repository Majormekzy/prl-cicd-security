output "role_arn" {
  description = "ARN of the terraform state access role"
  value       = aws_iam_role.terraform_state_access.arn
}

output "role_name" {
  description = "Name of the terraform state access role"
  value       = aws_iam_role.terraform_state_access.name
}