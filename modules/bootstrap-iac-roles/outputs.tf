output "iac_role_arns" {
  description = "Map of repository keys to IAC role ARNs"
  value = {
    for repo_key, role in aws_iam_role.iac_roles :
    repo_key => role.arn
  }
}

output "permissions_boundary_arn" {
  description = "ARN of the permissions boundary policy"
  value       = aws_iam_policy.iac_bootstrap_boundary.arn
}