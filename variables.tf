variable "public_key_name" {
  type = string
}

variable "private_key_name" {
  type = string
}
# RDS Variables
variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = "webapp"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

# 추가
variable "admin_user_arn" {
  description = "IAM Role ARN for bastion access (EKS admin)"
  type        = string
}