

################################################################
# Create IAC roles for each repository that targets this account
resource "aws_iam_role" "iac_roles" {
  for_each = var.repo_configs

  name = upper("PRL-${var.account_code}-GLBL-N-IAMROL-IAC-${upper(each.key)}")

  assume_role_policy = templatefile("${path.module}/templates/iac-trust-policy.json", {
    mgmt_account_id            = var.mgmt_account_id
    oidc_role_name             = upper("PRL-AUTOMATN-GLBL-N-IAMROL-OIDC-${upper(each.key)}-${var.account_code}")
    region                     = data.aws_region.current.name
    local_deployment_role_name = var.local_deployment_role_name
  })

  tags = merge(var.default_tags, {
    Name           = upper("PRL-${var.account_code}-GLBL-N-IAMROL-IAC-${upper(each.key)}")
    Repository     = each.key
    Purpose        = "IAC operations for ${each.key} in ${var.account_code}"
    TrustedAccount = var.mgmt_account_id
  })
}

# Attach managed policies to IAC roles
resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = {
    for combo in flatten([
      for repo_key, config in var.repo_configs : [
        for policy_arn in lookup(config, "managed_policies", []) : {
          role_key   = repo_key
          policy_arn = policy_arn
          key        = "${repo_key}-${basename(policy_arn)}"
        }
      ]
    ]) : combo.key => combo
  }

  role       = aws_iam_role.iac_roles[each.value.role_key].name
  policy_arn = each.value.policy_arn
}

# Attach inline policies to IAC roles
resource "aws_iam_role_policy" "inline_policies" {
  for_each = {
    for combo in flatten([
      for repo_key, config in var.repo_configs : [
        for policy_name, policy_doc in lookup(config, "policies", {}) : {
          role_key    = repo_key
          policy_name = policy_name
          policy_doc  = policy_doc
          key         = "${repo_key}-${policy_name}"
        }
      ]
    ]) : combo.key => combo
  }

  name   = each.value.policy_name
  role   = aws_iam_role.iac_roles[each.value.role_key].id
  policy = each.value.policy_doc
}