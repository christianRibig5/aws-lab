# ============================================================
# AWS LOAD BALANCER CONTROLLER - IAM
# ============================================================

# ------------------------------------------------------------
# EKS Pod Identity trust policy
# ------------------------------------------------------------

data "aws_iam_policy_document" "pod_identity_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

# ------------------------------------------------------------
# IAM role used by the controller Pod Identity
# ------------------------------------------------------------

resource "aws_iam_role" "load_balancer_controller" {
  name = "${data.terraform_remote_state.eks.outputs.eks_cluster_name}-${var.service_account_name}-role"

  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json

  tags = {
    Name        = "${data.terraform_remote_state.eks.outputs.eks_cluster_name}-${var.service_account_name}-role"
    Environment = var.environment_name
    Service     = "aws-load-balancer-controller"
    ManagedBy   = "terraform"
  }
}

# ------------------------------------------------------------
# AWS Load Balancer Controller permission policy
# ------------------------------------------------------------

resource "aws_iam_policy" "load_balancer_controller" {
  name = "${data.terraform_remote_state.eks.outputs.eks_cluster_name}-${var.service_account_name}-policy"

  policy = file(
    "${path.module}/policies/aws-load-balancer-controller-permission-policy.json"
  )

  tags = {
    Name        = "${data.terraform_remote_state.eks.outputs.eks_cluster_name}-${var.service_account_name}-policy"
    Environment = var.environment_name
    Service     = "aws-load-balancer-controller"
    ManagedBy   = "terraform"
  }
}

# ------------------------------------------------------------
# Attach permission policy to IAM role
# ------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role       = aws_iam_role.load_balancer_controller.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}
