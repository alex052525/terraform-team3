variable "namespace" {
  description = "모니터링 도구들을 설치할 네임스페이스"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "kube-prometheus-stack Helm 차트 버전"
  type        = string
  default     = "55.5.0"
}

variable "grafana_admin_password" {
  description = "Grafana 관리자 비밀번호"
  type        = string
  default     = "admin123!"
  sensitive   = true
}

variable "rds_host" {
  description = "RDS endpoint to connect from bastion"
  type        = string
}

variable "rds_user" {
  description = "RDS DB username"
  type        = string
}

variable "rds_password" {
  description = "RDS DB password"
  type        = string
}
