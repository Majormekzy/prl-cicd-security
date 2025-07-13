output "oidc_roles" {
  description = "All GitHub OIDC roles information"
  value = {
    for key, role in aws_iam_role.oidc_role : key => {
      arn        = role.arn
      name       = role.name
      repository = local.repo_accounts[key].full_repo_name
      account    = local.repo_accounts[key].account_code
    }
  }
}

output "repo_account_matrix" {
  description = "Repository to account mapping for reference"
  value       = local.repo_accounts
}

# # Add this to outputs.tf temporarily
# output "debug_first_combo" {
#   value = {
#     branches_raw = var.repositories.awscicdsecurity.branches
#     branches_formatted = local.repo_accounts["awscicdsecurity-mgmt"].branches
#     template_result = templatefile("${path.module}/templates/oidc-trust-policy.json", {
#       oidc_provider_arn = var.oidc_provider_arn
#       organization      = "PRLInfra"
#       repository        = "aws-cicd-security"
#       branches          = jsonencode(local.repo_accounts["awscicdsecurity-mgmt"].branches)
#     })
#   }
# }