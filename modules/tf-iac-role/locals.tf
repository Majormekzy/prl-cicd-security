# locals {
#   # # Convert repository name to consistent format for role naming
#   # repo_key = replace(replace(upper(var.repository_name), "-", ""), "_", "")

#   # ✅ IAC role name following your actual naming convention
#   iac_role_name = "PRL-${upper(var.account_code)}-GLBL-N-IAMROL-IAC-${local.repo_key}"

#   # ✅ OIDC role name that will assume this IAC role
#   oidc_role_name = "PRL-MGMT-GLBL-N-IAMROL-OIDC-${local.repo_key}-${upper(var.account_code)}"
# }