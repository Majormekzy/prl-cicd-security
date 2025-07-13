# locals {
#   region_vars     = read_terragrunt_config(find_in_parent_folders("region.hcl"))
#   account_vars    = read_terragrunt_config(find_in_parent_folders("account.hcl"))

#   # Core variables
#   aws_region                    = local.region_vars.locals.region
#   aws_region_code               = local.region_vars.locals.region_code
#   aws_account_id                = local.account_vars.locals.aws_account_id
#   aws_account_short_name        = local.account_vars.locals.aws_account_short_name
#   repo_name                     = "CICDSECURITY"
#   tf_iac_repo_account_role_name = upper("PRL-${local.aws_account_short_name}-GLBL-N-IAMROL-IAC-${local.repo_name}")
#   tf_iac_repo_account_role_arn  = "arn:aws:iam::${local.aws_account_id}:role/${local.tf_iac_repo_account_role_name}"
#   mgmt_account_id               = "114978791651"
#   env                           = local.account_vars.locals.env
  
#   # State configuration
#   state_bucket     = "prl-mgmt-${local.aws_region_code}-n-s3bukt--terraform-state"
#   state_lock_table = "prl-mgmt-${local.aws_region_code}-n-dynamo-terraform-locks"
  
#   # Check if we're in bootstrap mode
#   is_bootstrap = get_env("BOOTSTRAP_MODE", "false") == "true"
  
#   # GitHub repository
#   github_repository = "aws-cicd-security"
  
#   # Default tags
#   default_tags = {
#     GENERATED-BY         = "terraform"
#     ENVIRONMENT          = local.env
#     BUSINESS-APPLICATION = "Network Foundation"
#     BUSINESS-OWNER       = "Mike Han"
#     BUSINESS-CUSTODIAN   = "Jeremy Lumgair"
#     TECHNICAL-OWNER      = "Emeka Machie"
#     TECHNICAL-SUPPORT    = "Emeka Machie"
#     COST-CENTER          = "DEP003.635.350"
#     ACCOUNT-ID           = local.aws_account_id
#     GITHUB_REPO          = local.github_repository
#   }
# }

# # Remote state configuration
# remote_state {
#   backend = "s3"
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
#   config = {
#     bucket         = local.state_bucket
#     key            = "cicd-security/${basename(get_parent_terragrunt_dir())}/${path_relative_to_include()}/terraform.tfstate"
#     region         = local.aws_region
#     encrypt        = true
#     dynamodb_table = local.state_lock_table
#   }
# }

# # Provider generation with conditional assume_role
# generate "provider" {
#   path      = "provider.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region = "${local.aws_region}"
#     ${local.is_bootstrap ? "" : "assume_role {\n    role_arn = \"${local.tf_iac_repo_account_role_arn}\"\n  }"}
#   default_tags {
#     tags = {
#       GENERATED-BY         = "${local.default_tags.GENERATED-BY}"
#       ENVIRONMENT          = "${local.default_tags.ENVIRONMENT}"
#       BUSINESS-APPLICATION = "${local.default_tags.BUSINESS-APPLICATION}"
#       BUSINESS-OWNER       = "${local.default_tags.BUSINESS-OWNER}"
#       BUSINESS-CUSTODIAN   = "${local.default_tags.BUSINESS-CUSTODIAN}"
#       TECHNICAL-OWNER      = "${local.default_tags.TECHNICAL-OWNER}"
#       TECHNICAL-SUPPORT    = "${local.default_tags.TECHNICAL-SUPPORT}"
#       COST-CENTER          = "${local.default_tags.COST-CENTER}"
#       ACCOUNT-ID           = "${local.default_tags.ACCOUNT-ID}"
#       GITHUB_REPO          = "${local.default_tags.GITHUB_REPO}"
#     }
#   }
# }
# EOF
# }

# # Combine all variables
# inputs = merge(
#   local.account_vars.locals,
#   local.region_vars.locals,
#   {
#     default_tags = local.default_tags
#     mgmt_account_id = local.mgmt_account_id
#   }
# )

# ######################################################################
# # locals {
# #   region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
# #   account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

# #   # Derived variables from regional and account variables
# #   aws_region                    = local.region_vars.locals.region
# #   aws_region_code               = local.region_vars.locals.region_code
# #   aws_account_id                = local.account_vars.locals.aws_account_id
# #   aws_account_short_name        = local.account_vars.locals.aws_account_short_name
# #   repo_name                     = "CICDSECURITY"
# #   tf_iac_repo_account_role_name = upper("AWS-${local.aws_account_short_name}-GLBL-N-IAMROL-IAC-${local.repo_name}")
# #   tf_iac_repo_account_role_arn  = "arn:aws:iam::${local.aws_account_id}:role/${local.tf_iac_repo_account_role_name}"
# #   automation_account_id         = "048266892181"
# #   env                           = local.account_vars.locals.env

# #   # Derived variables for TF state and lock (CENTRALIZED)
# #   state_bucket     = "aws-automatn-usw2-n-s3bukt-terraform-state"
# #   state_lock_table = "aws-automatn-usw2-n-dynamo-terraform-locks"

# #   # Github Repo name
# #   github_repository = "aws-cicd-security"

# #   # Other Variables 
# #   module_directory = basename(get_terragrunt_dir())

# #   # Tags to be added to provider
# #   default_tags = {
# #     GENERATED-BY         = "terraform"
# #     ENVIRONMENT          = local.env
# #     BUSINESS-APPLICATION = "CICD SECURITY"
# #     BUSINESS-OWNER       = "Mike Han"
# #     BUSINESS-CUSTODIAN   = "Jeremy Lumgair"
# #     TECHNICAL-OWNER      = "Emeka Machie"
# #     TECHNICAL-SUPPORT    = "Emeka Machie"
# #     COST-CENTER          = "DEP003.635.350"
# #     ACCOUNT-ID           = local.aws_account_id
# #     GITHUB_REPO          = local.github_repository
# #   }
# # }

# # remote_state {
# #   backend = "s3"
# #   generate = {
# #     path      = "backend.tf"
# #     if_exists = "overwrite_terragrunt"
# #   }
# #   config = {
# #     bucket         = local.state_bucket
# #     key            = "cicd-security/${basename(get_parent_terragrunt_dir())}/${path_relative_to_include()}/terraform.tfstate"
# #     region         = local.aws_region
# #     encrypt        = true
# #     dynamodb_table = local.state_lock_table
# #   }
# # }

# # generate "provider" {
# #   path      = "provider.tf"
# #   if_exists = "overwrite_terragrunt"
# #   contents  = <<EOF
# # provider "aws" {
# #   region = "${local.aws_region}"
# #   assume_role {
# #     role_arn = "${local.tf_iac_repo_account_role_arn}"
# #   }
# #   default_tags {
# #     tags = {
# #       GENERATED-BY         = "${local.default_tags.GENERATED-BY}"
# #       ENVIRONMENT          = "${local.default_tags.ENVIRONMENT}"
# #       BUSINESS-APPLICATION = "${local.default_tags.BUSINESS-APPLICATION}"
# #       BUSINESS-OWNER       = "${local.default_tags.BUSINESS-OWNER}"
# #       BUSINESS-CUSTODIAN   = "${local.default_tags.BUSINESS-CUSTODIAN}"
# #       TECHNICAL-OWNER      = "${local.default_tags.TECHNICAL-OWNER}"
# #       TECHNICAL-SUPPORT    = "${local.default_tags.TECHNICAL-SUPPORT}"
# #       COST-CENTER          = "${local.default_tags.COST-CENTER}"
# #       ACCOUNT-ID           = "${local.default_tags.ACCOUNT-ID}"
# #       GITHUB_REPO          = "${local.default_tags.GITHUB_REPO}"
# #     }
# #   }
# # }
# # EOF
# # }

# # # Combine all variables
# # inputs = merge(
# #   local.account_vars.locals,
# #   local.region_vars.locals,
# #   {
# #     default_tags = local.default_tags
# #     automation_account_id = local.automation_account_id
# #   }
# # )

locals {
  region_vars     = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  account_vars    = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Core variables
  aws_region                    = local.region_vars.locals.region
  aws_region_code               = local.region_vars.locals.region_code
  aws_account_id                = local.account_vars.locals.aws_account_id
  aws_account_short_name        = local.account_vars.locals.aws_account_short_name
  repo_name                     = "CICDSECURITY"
  tf_iac_repo_account_role_name = upper("PRL-${local.aws_account_short_name}-GLBL-N-IAMROL-IAC-${local.repo_name}")
  tf_iac_repo_account_role_arn  = "arn:aws:iam::${local.aws_account_id}:role/${local.tf_iac_repo_account_role_name}"
  mgmt_account_id               = "114978791651"
  env                           = local.account_vars.locals.env
  
  # State configuration
  state_bucket     = "prl-mgmt-${local.aws_region_code}-n-s3bukt--terraform-state"
  state_lock_table = "prl-mgmt-${local.aws_region_code}-n-dynamo-terraform-locks"
  
  # Bootstrap mode detection
  is_bootstrap = get_env("BOOTSTRAP_MODE", "false") == "true"
  
  # GitHub repository
  github_repository = "aws-cicd-security"
  
  # Default tags
  default_tags = {
    GENERATED-BY         = "terraform"
    ENVIRONMENT          = local.env
    BUSINESS-APPLICATION = "Network Foundation"
    BUSINESS-OWNER       = "Mike Han"
    BUSINESS-CUSTODIAN   = "Jeremy Lumgair"
    TECHNICAL-OWNER      = "Emeka Machie"
    TECHNICAL-SUPPORT    = "Emeka Machie"
    COST-CENTER          = "DEP003.635.350"
    ACCOUNT-ID           = local.aws_account_id
    GITHUB_REPO          = local.github_repository
  }
}

# Provider generation with conditional assume_role
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  
  %{if local.is_bootstrap}
  # Bootstrap mode: Assume OrganizationAccountAccessRole for cross-account IAC creation
  assume_role {
    role_arn     = "arn:aws:iam::${local.aws_account_id}:role/OrganizationAccountAccessRole"
    external_id  = "bootstrap-iac-roles"
    session_name = "bootstrap-iac-roles-session"
  }
  %{else}
  # Regular mode: Assume the IAC role that was created during bootstrap
  assume_role {
    role_arn = "${local.tf_iac_repo_account_role_arn}"
  }
  %{endif}
  
  default_tags {
    tags = {
      GENERATED-BY         = "${local.default_tags.GENERATED-BY}"
      ENVIRONMENT          = "${local.default_tags.ENVIRONMENT}"
      BUSINESS-APPLICATION = "${local.default_tags.BUSINESS-APPLICATION}"
      BUSINESS-OWNER       = "${local.default_tags.BUSINESS-OWNER}"
      BUSINESS-CUSTODIAN   = "${local.default_tags.BUSINESS-CUSTODIAN}"
      TECHNICAL-OWNER      = "${local.default_tags.TECHNICAL-OWNER}"
      TECHNICAL-SUPPORT    = "${local.default_tags.TECHNICAL-SUPPORT}"
      COST-CENTER          = "${local.default_tags.COST-CENTER}"
      ACCOUNT-ID           = "${local.default_tags.ACCOUNT-ID}"
      GITHUB_REPO          = "${local.default_tags.GITHUB_REPO}"
    }
  }
}
EOF
}