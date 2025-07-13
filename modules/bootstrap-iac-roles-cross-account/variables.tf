variable "target_account_id" {
  description = "Target AWS account ID where IAC roles will be created"
  type        = string
}

variable "target_account_code" {
  description = "Short code for the target account (e.g., SNPRD, SPRD)"
  type        = string
}

variable "mgmt_account_id" {
  description = "Management account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "repo_configs" {
  description = "Configuration for each repository's IAC role"
  type = map(object({
    managed_policies = optional(list(string), [])
    custom_policies  = optional(map(string), {})
  }))
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "external_id" {
  description = "External ID for additional security"
  type        = string
  default     = "bootstrap-iac-roles"
}

variable "local_deployment_role_name" {
  description = "SSO role name for local deployments"
  type        = string
  default     = "AWSAdministratorAccess"
}

variable "state_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "state_lock_table" {
  description = "DynamoDB table for state locking"
  type        = string
}