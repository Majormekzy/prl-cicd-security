include {
  path = find_in_parent_folders("root.hcl")
}

include "region" {
  path = find_in_parent_folders("region.hcl")
}

include "account" {
  path = find_in_parent_folders("account.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/tf-oidc-provider"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}



# The account is determined by:
# 1. The AWS provider configuration in root.hcl/account.hcl
# 2. The directory structure: aws-sec-net-prod = target account
# 3. The account.hcl file defines account_id = "123456789012" (your central security account)