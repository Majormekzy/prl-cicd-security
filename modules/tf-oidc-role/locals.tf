
locals {
  # Create combinations of repositories and their allowed target accounts
  repo_account_combinations = flatten([
    for repo_key, repo_config in var.repositories : [
      for account_key in repo_config.iac_accounts : {
        key          = "${repo_key}-${account_key}"
        repo_key     = repo_key
        account_key  = account_key
        repository   = repo_config.repository
        organization = repo_config.organization
        branches = [
          for branch in repo_config.branches :
          "repo:${repo_config.organization}/${repo_config.repository}:ref:refs/heads/${branch}"
        ]
        account_id     = var.iac_accounts[account_key].account_id
        account_code   = var.iac_accounts[account_key].account_code
        full_repo_name = "${repo_config.organization}/${repo_config.repository}"
      }
    ]
  ])

  repo_accounts = {
    for combo in local.repo_account_combinations : combo.key => combo
  }
}