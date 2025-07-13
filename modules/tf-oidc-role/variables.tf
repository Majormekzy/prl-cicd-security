
variable "repositories" {
  description = "GitHub repositories configuration"
  type = map(object({
    organization = string
    repository   = string
    iac_accounts = list(string)                     # Which accounts this repo can deploy to
    branches     = optional(list(string), ["main"]) # Allowed branches, defaults to ["main"]
  }))
}

variable "iac_accounts" {
  description = "All target AWS accounts where IAC roles exist"
  type = map(object({
    account_id   = string
    account_code = string
  }))
}

variable "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

variable "tf_state_bucket" {
  description = "The name of the terraform state bucket"
  type        = string
}

variable "tf_state_table" {
  description = "The name of the terraform state bucket"
  type        = string
}