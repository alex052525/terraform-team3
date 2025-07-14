

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = var.namespace
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  create_namespace = false # true로 변경

  # values = [file("${path.module}/values.yaml")]
}

