# variable "repository_name" {
#   description = "Name of the GitHub repository"
#   type        = string
# }

# variable "region_code" {
#   description = "Region code (e.g., usw2)"
#   type        = string
# }

# variable "account_code" {
#   description = "Account code (e.g., eucnprd)"
#   type        = string
# }

# variable "mgmt_account_id" {
#   description = "AWS account ID where OIDC provider and roles are hosted"
#   type        = string
# }

# variable "permissions_policies" {
#   description = "List of IAM policy ARNs to attach to the IAC role"
#   type        = list(string)
#   default     = []
# }

# variable "inline_policies" {
#   description = "Map of inline policies to attach to the IAC role"
#   type        = map(string)
#   default     = {}
# }

# variable "tags" {
#   description = "Resource tags"
#   type        = map(string)
#   default     = {}
# }


variable "account_code" {
  description = "Account short code (e.g., SCNTPROD)"
  type        = string
}

variable "mgmt_account_id" {
  description = "Automation account ID"
  type        = string
  default     = "048266892181"
}

variable "repo_configs" {
  description = "Map of repository configurations"
  type = map(object({
    policies         = optional(map(string), {})  # Inline policies
    managed_policies = optional(list(string), []) # Managed policy ARNs
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