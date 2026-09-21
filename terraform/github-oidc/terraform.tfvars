github_owner = "christianRibig5"

github_repositories = [
  "python-gitops-workflow-demo"
]

github_branches = [
  "main"
]

repository_subject_prefixes = {
  python-gitops-workflow-demo = "repo:ChristianRibig5@34343657/python-gitops-workflow-demo@1358807034"
  # When you start project-B, you don't modify the module. Get its GitHub OIDC configuration:
  #  gh api repos/christianRibig5/project-B/actions/oidc/customization/sub
}


role_name = "aws-lab-github-actions"

# No ECR repository is currently authorized.
ecr_repository_arns = []

# No EKS cluster is currently authorized.
eks_cluster_arns = []

create_oidc_provider = true

max_session_duration = 3600
