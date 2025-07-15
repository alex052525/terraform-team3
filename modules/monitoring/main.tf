# Prometheus와 Grafana를 설치하는 모듈

# monitoring 네임스페이스 생성
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

# kube-prometheus-stack 설치 (Prometheus + Grafana + AlertManager 포함)
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # Grafana 설정
  set = [
    {
      name  = "grafana.enabled"
      value = "true"
    },
    {
      name  = "grafana.adminPassword"
      value = var.grafana_admin_password
    },
    {
      name  = "grafana.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "prometheus.prometheus.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "alertmanager.enabled"
      value = "true"
    }
  ]

  depends_on = [kubernetes_namespace.monitoring]
}