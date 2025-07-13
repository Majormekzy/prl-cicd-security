# output "iac_role_arns" {
#   description = "Map of repository keys to IAC role ARNs"
#   value = {
#     for repo_key, role in aws_iam_role.iac_roles :
#     repo_key => role.arn
#   }
# }

# output "iac_role_names" {
#   description = "Map of repository keys to IAC role names"
#   value = {
#     for repo_key, role in aws_iam_role.iac_roles :
#     repo_key => role.name
#   }
# }

# output "permissions_boundary_arn" {
#   description = "ARN of the permissions boundary policy"
#   value       = aws_iam_policy.iac_bootstrap_boundary.arn
# }

output "iac_role_arns" {
  description = "ARNs of created IAC roles"
  value = {
    for k, v in aws_iam_role.iac_roles : k => v.arn
  }
}

output "iac_role_names" {
  description = "Names of created IAC roles"
  value = {
    for k, v in aws_iam_role.iac_roles : k => v.name
  }
}