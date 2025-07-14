include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/iac-roles"
}

locals {
  repo_configs = {
    cicdsecurity = {
      policies = {
        SecurityCustomPolicy = jsonencode({
          Version = "2012-10-17"
          Statement = [
            {
              Sid    = "SecurityPermissions"
              Effect = "Allow"
              Action = [
                "iam:*",
                "organizations:*",
                "budgets:*",
                "sts:*",
                "config:*",
                "cloudtrail:*",
                "guardduty:*",
                "securityhub:*"
              ]
              Resource = "*"
            }
          ]
        })
      }
    }
  }
}

inputs = {
  account_code    = "SNPRD"
  mgmt_account_id = "114978791651"
  repo_configs    = local.repo_configs
}