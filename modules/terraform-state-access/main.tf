resource "aws_iam_role" "terraform_state_access" {
  name = "TerraformStateAccess"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_account_arns
        }
      }
    ]
  })

  tags = var.tags
}

# ENHANCED: Add IAM permissions for bootstrap
resource "aws_iam_role_policy" "terraform_state_access" {
  name = "TerraformStateAccess"
  role = aws_iam_role.terraform_state_access.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AccessTerraformStateBucket"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketVersioning",
          "s3:GetBucketPolicy",
          "s3:GetBucketLocation",
          "s3:GetEncryptionConfiguration"
        ]
        Resource = [
          var.state_bucket_arn,
          "${var.state_bucket_arn}/*"
        ]
      },
      {
        Sid    = "AccessTerraformStateLocks"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = var.dynamodb_table_arn
      },
      {
        Sid    = "BootstrapIAMPermissions"
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:PutRolePolicy",
          "iam:AttachRolePolicy",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListRolePolicies",
          "iam:TagRole",
          "iam:UpdateRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:CreatePolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",
          "iam:TagPolicy"
        ]
        Resource = [
          "arn:aws:iam::730335485168:role/AWS-SNPRD-GLBL-N-IAMROL-IAC-*",
          "arn:aws:iam::730335485168:policy/IAC-Bootstrap-Boundary",


        ]
      }
    ]
  })
}



