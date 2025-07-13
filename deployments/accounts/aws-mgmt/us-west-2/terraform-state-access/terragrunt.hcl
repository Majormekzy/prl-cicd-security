# deployments/account/aws-automation/us-west-2/terraform-state-access/terragrunt.hcl

include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/terraform-state-access"
}

inputs = {
  trusted_account_arns = [
    "arn:aws:iam::114978791651:root",  # aws-mgmt (self)
    "arn:aws:iam::730335485168:root",  # aws-shared-non-prod
    "arn:aws:iam::058264438918:root",  # aws-shared-prod
  ]
  
  state_bucket_arn     = "arn:aws:s3:::prl-mgmt-usw2-n-s3bukt--terraform-state"  # Updated
  dynamodb_table_arn   = "arn:aws:dynamodb:us-west-2:114978791651:table/prl-mgmt-usw2-n-dynamo-terraform-locks"  # Updated
}