aws_region          = "ca-central-1"
awscli_user_profile = "dev-admin"

environment_name = "dev"

# Add repositories here when a workload requires ECR.
ecr_repositories = {}
# ecr_repositories = {
#   python-app = {
#     repository_name = "python-app"
#     artifact_type   = "Container"
#     keep_versions   = 10
#     scan_on_push    = true
#     force_delete    = false or true
#   }
# }

# OR
# ecr_repositories = {
#   python-app = {
#     repository_name = "python-app"
#     artifact_type   = "Container"
#   }

#   python-chart = {
#     repository_name = "python-chart"
#     artifact_type   = "Helm"
#   }
# }

common_tags = {
  Project   = "aws-lab"
  ManagedBy = "Terraform"
}

