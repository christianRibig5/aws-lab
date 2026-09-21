# ============================================================
# AWS LOAD BALANCER CONTROLLER - SERVICE ACCOUNT
# ============================================================

resource "kubernetes_service_account_v1" "load_balancer_controller" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}
