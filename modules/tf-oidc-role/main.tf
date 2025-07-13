# OIDC Roles - One per repository per target account combination
resource "aws_iam_role" "oidc_role" {
  for_each = local.repo_accounts
  
  # Updated naming convention to match your existing pattern
  name = upper("PRL-MGMT-GLBL-N-IAMROL-OIDC-${each.value.repo_key}-${each.value.account_code}")
  
  assume_role_policy = templatefile("${path.module}/templates/oidc-trust-policy.json", {
    oidc_provider_arn = var.oidc_provider_arn
    organization      = each.value.organization
    repository        = each.value.repository
    branches          = jsonencode(each.value.branches)
  })
  
  tags = merge(var.tags, {
    Name          = upper("PRL-MGMT-GLBL-N-IAMROL-OIDC-${each.value.repo_key}-${each.value.account_code}")
    Repository    = each.value.full_repo_name
    TargetAccount = each.value.account_code
    Purpose       = "GitHub Actions OIDC authentication"
  })
}

# Policy to assume IAC roles in target accounts
resource "aws_iam_policy" "oidc_policy" {
  for_each = local.repo_accounts
  
  # Updated naming convention
  name        = upper("PRL-MGMT-GLBL-N-IAMPOL-OIDC-${each.value.repo_key}-${each.value.account_code}")
  description = "Allow assuming IAC role in ${each.value.account_code} for ${each.value.repository}"
  
  policy = templatefile("${path.module}/templates/oidc-assume-policy.json", {
    target_account_id = each.value.account_id
    repo_key          = upper(each.value.repo_key)
    account_code      = upper(each.value.account_code)
    region            = data.aws_region.current.name
    account_id        = data.aws_caller_identity.current.account_id
    tf_state_table    = var.tf_state_table
    tf_state_bucket   = var.tf_state_bucket
  })
  
  tags = var.tags
}

# Attach assume policy to OIDC role
resource "aws_iam_role_policy_attachment" "oidc_policy" {
  for_each = local.repo_accounts
  
  role       = aws_iam_role.oidc_role[each.key].name
  policy_arn = aws_iam_policy.oidc_policy[each.key].arn
}