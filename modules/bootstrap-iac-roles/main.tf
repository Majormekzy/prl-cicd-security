# Create permissions boundary policy first
resource "aws_iam_policy" "iac_bootstrap_boundary" {
  name        = "IAC-Bootstrap-Boundary"
  description = "Permissions boundary for IAC roles created during bootstrap"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyDangerousActions"
        Effect = "Deny"
        Action = [
          "iam:CreateUser",
          "iam:DeleteUser",
          "iam:CreateAccessKey",
          "iam:DeleteAccessKey",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy"
        ]
        Resource = "*"
        Condition = {
          StringNotLike = {
            "aws:PrincipalArn" = [
              "arn:aws:iam::${var.mgmt_account_id}:role/AWS-AUTOMATN-GLBL-N-IAMROL-OIDC-*",
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWS-*-GLBL-N-IAMROL-IAC-*"
            ]
          }
        }
      },
      {
        Sid      = "AllowBootstrapPermissions"
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })

  tags = var.default_tags
}

# Create IAC roles for each repository that targets this account
resource "aws_iam_role" "iac_roles" {
  for_each = var.repo_configs

  name                 = upper("PRL-${var.account_code}-GLBL-N-IAMROL-IAC-${upper(each.key)}")
  permissions_boundary = aws_iam_policy.iac_bootstrap_boundary.arn

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${var.mgmt_account_id}:role/AWS-AUTOMATN-GLBL-N-IAMROL-OIDC-${upper(each.key)}-${var.account_code}"
          ]
        }
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.mgmt_account_id}:role/aws-reserved/sso.amazonaws.com/${data.aws_region.current.name}/${var.local_deployment_role_name}"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.default_tags, {
    Repository = each.key
    Purpose    = "IAC Role for ${each.key} repository"
    Bootstrap  = "true"
  })
}

# Attach policies to IAC roles
resource "aws_iam_role_policy" "iac_role_policies" {
  for_each = {
    for combo in flatten([
      for repo_key, config in var.repo_configs : [
        for policy_name, policy_doc in config.policies : {
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
