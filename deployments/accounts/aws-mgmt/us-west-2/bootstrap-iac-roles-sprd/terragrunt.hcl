# Bootstrap IAC roles for SPRD account (058264438918)
# Run from management account to create roles in SPRD

locals {
  # Read management account region config
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Management account details (where this runs)
  aws_region      = local.region_vars.locals.region
  aws_region_code = local.region_vars.locals.region_code
  mgmt_account_id = local.account_vars.locals.aws_account_id # 114978791651
  env             = local.account_vars.locals.env

  # Target account details (where roles will be created)
  target_account_id   = "058264438918" # SPRD account ID (replace with actual)
  target_account_code = "SPRD"

  # State configuration (stays in management account)
  state_bucket     = "prl-mgmt-${local.aws_region_code}-n-s3bukt--terraform-state"
  state_lock_table = "prl-mgmt-${local.aws_region_code}-n-dynamo-terraform-locks"

  # Default tags
  default_tags = {
    GENERATED-BY         = "terraform"
    ENVIRONMENT          = "PRODUCTION"
    BUSINESS-APPLICATION = "CICD SECURITY"
    BUSINESS-OWNER       = "Mike Han"
    BUSINESS-CUSTODIAN   = "Jeremy Lumgair"
    TECHNICAL-OWNER      = "Emeka Machie"
    TECHNICAL-SUPPORT    = "Emeka Machie"
    COST-CENTER          = "DEP003.635.350"
    ACCOUNT-ID           = local.target_account_id # Target account ID
    GITHUB_REPO          = "aws-cicd-security"
    TARGET-ACCOUNT       = "SPRD"
  }

  # Repository configurations for SPRD (same as SNPRD but could be different)
  repo_configs = {
    cicdsecurity = {
      custom_policies = {
        SecurityCustomPolicy = jsonencode({
          Version = "2012-10-17"
          Statement = [
            {
              Sid    = "SecurityPermissions"
              Effect = "Allow"
              Action = [
                "iam:*",
                "organizations:DescribeOrganization",
                "organizations:ListAccounts",
                "budgets:*",
                "config:*",
                "cloudtrail:*",
                "guardduty:*",
                "securityhub:*"
              ]
              Resource = "*"
            },
            {
              Sid    = "DenyDangerousIAMActions"
              Effect = "Deny"
              Action = [
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey"
              ]
              Resource = "*"
            }
          ]
        })
      }
    }

    networkfoundation = {
      custom_policies = {
        NetworkCustomPolicy = jsonencode({
          Version = "2012-10-17"
          Statement = [
            {
              Sid    = "NetworkPermissions"
              Effect = "Allow"
              Action = [
                "ec2:*",
                "vpc:*",
                "route53:*",
                "route53resolver:*",
                "directconnect:*",
                "ram:*",
                "networkfirewall:*",
                "globalaccelerator:*",
                "elasticloadbalancing:*"
              ]
              Resource = "*"
              Condition = {
                StringEquals = {
                  "aws:RequestedRegion" = local.aws_region
                }
              }
            }
          ]
        })
      }
    }
  }
}

terraform {
  source = "${get_repo_root()}/modules/bootstrap-iac-roles-cross-account"
}

# Generate provider for SPRD target account
generate "target_provider" {
  path      = "target-provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  alias  = "target"
  region = "${local.aws_region}"
  
  assume_role {
    role_arn     = "arn:aws:iam::${local.target_account_id}:role/OrganizationAccountAccessRole"
    external_id  = "bootstrap-iac-roles"
    session_name = "bootstrap-iac-roles-sprd-session"
  }
  
  default_tags {
    tags = merge(
      ${jsonencode(local.default_tags)},
      {
        BOOTSTRAP    = "true"
        MANAGED-BY   = "mgmt-account"
      }
    )
  }
}
EOF
}

inputs = {
  target_account_id          = local.target_account_id
  target_account_code        = local.target_account_code
  mgmt_account_id            = local.mgmt_account_id
  aws_region                 = local.aws_region
  repo_configs               = local.repo_configs
  state_bucket               = local.state_bucket
  state_lock_table           = local.state_lock_table
  local_deployment_role_name = "AWSAdministratorAccess"
  external_id                = "bootstrap-iac-roles"
}