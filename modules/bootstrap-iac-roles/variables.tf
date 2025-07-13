variable "account_code" {
  description = "Account short code (e.g., SCNTPROD)"
  type        = string
}

variable "mgmt_account_id" {
  description = "Automation account ID"
  type        = string
  default     = "114978791651"
}

variable "repo_configs" {
  description = "Map of repository configurations"
  type = map(object({
    policies = map(string)
  }))
}

variable "default_tags" {
  description = "Default tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "local_deployment_role_name" {
  description = "Local deployment role name for SSO access"
  type        = string
  default     = "AWSReservedSSO_DeploymentRole_12345678"
}