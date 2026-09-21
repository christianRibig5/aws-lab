# EBS CSI Pod Identity trust policy

data "aws_iam_policy_document" "ebs_csi_pod_identity_trust" {
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


# IAM role used by the EBS CSI controller through EKS Pod Identity

resource "aws_iam_role" "ebs_csi" {
  name = "${var.environment_name}-ebs-csi-controller"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_pod_identity_trust.json

  tags = merge(
    var.tags,
    {
      Component = "ebs-csi"
    }
  )
}


# AWS-managed permissions required by the EBS CSI Driver

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role = aws_iam_role.ebs_csi.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
