

include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/tf-oidc-role"
}

dependency "oidc_provider" {
  config_path = "../oidc-provider"
  
  # mock_outputs = {
  #   oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
  # }
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
  oidc_provider_arn = dependency.oidc_provider.outputs.oidc_provider_arn
  tf_state_bucket   = "aws-mgmt-usw2-n-s3bukt--terraform-state"
  tf_state_table    = "aws-mgmt-usw2-n-dynamo-terraform-locks"
  
  # Define all repositories and their allowed target accounts
  repositories = {
    awscicdsecurity = {
      organization = "PRLInfra"
      repository   = "aws-cicd-security"
      iac_accounts = ["snprd", "sprd", "mgmt"]
      branches     = ["main", "feat/*", "fix/*"]  # Allow main and feature/fix branches
    }

    awsnetworkfoundation = {
      organization = "PRLInfra"
      repository   = "aws-cicd-security"
      iac_accounts = ["snprd", "sprd", "mgmt"]
      branches     = ["main", "feat/*", "fix/*"]  # Allow main and feature/fix branches
    }
    # Uncomment and add other repositories as needed
    # awsinfrastorage = {
    #   organization = "PRLInfra"
    #   repository   = "aws-infra-storage"
    #   iac_accounts = ["snprd", "sprd"]
    #   branches     = ["main", "develop"]
    # }
    # awsinfracompute = {
    #   organization = "PRLInfra"
    #   repository   = "aws-infra-compute"
    #   iac_accounts = ["snprd", "sprd"]
    #   branches     = ["main"]  # Only allow main branch
    # }
  }
  
  # Define all target accounts
  iac_accounts = {
    snprd = {
      account_id   = "730335485168"
      account_code = "snprd"
    }
    sprd = {
      account_id   = "058264438918"
      account_code = "sprd"
    }
    mgmt = {
      account_id   = "114978791651"
      account_code = "mgmt"
    }
  }
  
  # Pass default tags
  tags = {
    MODULE = "oidc-role"
  }
}