output "ecr_repository_urls" {
  description = "Map of repository keys to ECR repository URLs"

  value = {
    for key, repository in module.ecr_repositories :
    key => repository.repository_url
  }
}

output "ecr_repository_arns" {
  description = "Map of repository keys to ECR repository ARNs"

  value = {
    for key, repository in module.ecr_repositories :
    key => repository.repository_arn
  }
}

output "ecr_repository_names" {
  description = "Map of repository keys to ECR repository names"

  value = {
    for key, repository in module.ecr_repositories :
    key => repository.repository_name
  }
}
