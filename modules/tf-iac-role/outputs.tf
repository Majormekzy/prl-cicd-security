output "iac_role_arns" {
  description = "Map of repository keys to IAC role ARNs"
  value = {
    for repo_key, role in aws_iam_role.iac_roles :
    repo_key => role.arn
  }
}

output "iac_role_names" {
  description = "Map of repository keys to IAC role names"
  value = {
    for repo_key, role in aws_iam_role.iac_roles :
    repo_key => role.name
  }
}