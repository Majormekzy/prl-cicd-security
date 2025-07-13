# Create IAC roles in target account
resource "aws_iam_role" "iac_roles" {
  provider = aws.target

  for_each = var.repo_configs

  name = upper("PRL-${var.target_account_code}-GLBL-N-IAMROL-IAC-${upper(each.key)}")

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = [
            # OIDC role from management account - Both roles exist now!
            "arn:aws:iam::${var.mgmt_account_id}:role/PRL-MGMT-GLBL-N-IAMROL-OIDC-AWS${upper(each.key)}-${var.target_account_code}",
            # Allow management account root for emergency access
            "arn:aws:iam::${var.mgmt_account_id}:root"
          ]
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
      #   {
      #     # Allow SSO Administrator role for manual access
      #     Action = "sts:AssumeRole"
      #     Effect = "Allow"
      #     Principal = {
      #       AWS = "arn:aws:iam::${var.mgmt_account_id}:role/AWSReservedSSO_AWSAdministratorAccess_d24152c191e58617"
      #     }
      #   }
    ]
  })

  tags = merge(var.default_tags, {
    Repository = each.key
    Purpose    = "IAC Role for ${each.key} repository"
  })
}

# Attach managed policies to IAC roles
resource "aws_iam_role_policy_attachment" "iac_role_managed_policies" {
  provider = aws.target

  for_each = {
    for combo in flatten([
      for repo_key, config in var.repo_configs : [
        for policy in lookup(config, "managed_policies", []) : {
          role_key = repo_key
          policy   = policy
        }
      ]
    ]) : "${combo.role_key}-${combo.policy}" => combo
  }

  role       = aws_iam_role.iac_roles[each.value.role_key].id
  policy_arn = each.value.policy
}

# Create and attach custom policies to IAC roles
resource "aws_iam_role_policy" "iac_role_policies" {
  provider = aws.target

  for_each = {
    for combo in flatten([
      for repo_key, config in var.repo_configs : [
        for policy_name, policy_doc in lookup(config, "custom_policies", {}) : {
          role_key    = repo_key
          policy_name = policy_name
          policy_doc  = policy_doc
        }
      ]
    ]) : "${combo.role_key}-${combo.policy_name}" => combo
  }

  name   = each.value.policy_name
  role   = aws_iam_role.iac_roles[each.value.role_key].id
  policy = each.value.policy_doc
}

# Create state access policy for cross-account state management
resource "aws_iam_role_policy" "state_access" {
  provider = aws.target

  for_each = var.repo_configs

  name = "StateAccess"
  role = aws_iam_role.iac_roles[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "StateS3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.state_bucket}/*",
          "arn:aws:s3:::${var.state_bucket}"
        ]
      },
      {
        Sid    = "StateDynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:${var.aws_region}:${var.mgmt_account_id}:table/${var.state_lock_table}"
      }
    ]
  })
}