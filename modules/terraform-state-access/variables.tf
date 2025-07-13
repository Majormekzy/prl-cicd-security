variable "trusted_account_arns" {
  description = "List of account ARNs that can assume this role"
  type        = list(string)
}

variable "state_bucket_arn" {
  description = "ARN of the terraform state bucket"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of the terraform state lock table"
  type        = string
}

variable "tags" {
  description = "Default tags to apply to resources"
  type        = map(string)
  default     = {}
}