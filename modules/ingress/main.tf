provider "kubernetes" {
  config_path = var.kubeconfig_path
}

resource "kubernetes_ingress" "argocd_ingress" {
  metadata {
    name      = "ingress"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      # 필요시 인증 등 추가 annotation
    }
  }

  spec {
    rule {
      http {
        path {
            path     = "/argocd"

            backend {
                service_name = "argocd"
                service_port = 80
            }
        }

        path {
            path = "/app"
            backend {
                service_name = "app"
                service_port = 80
            }
        }
      }
    }
  }
}
