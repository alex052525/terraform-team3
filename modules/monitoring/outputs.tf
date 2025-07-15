# monitoring 모듈에서 출력할 정보들

output "namespace" {
  description = "모니터링 네임스페이스 이름"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "prometheus_release_name" {
  description = "Prometheus Helm 릴리즈 이름"
  value       = helm_release.kube_prometheus_stack.name
}

output "grafana_admin_password" {
  description = "Grafana 관리자 비밀번호"
  value       = var.grafana_admin_password
  sensitive   = true
}