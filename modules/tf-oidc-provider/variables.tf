variable "github_thumbprints" {
  description = "GitHub OIDC provider thumbprints"
  type        = list(string)
  default = [
    "7560d6f40fa55195f740ee2b1b7c0b4836cbe103",
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

