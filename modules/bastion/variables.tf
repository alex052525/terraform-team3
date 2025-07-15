variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.large"
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "private_ip" {
  type    = string
  default = null
}

#bastion
variable "bastion_iam_role_name" {
  description = "Name of IAM Role to attach to the Bastion instance"
  type        = string
}

variable "rds_host" {
  description = "RDS endpoint for bastion user-data connection"
  type        = string
}

variable "rds_user" {
  description = "RDS username for bastion"
  type        = string
}

variable "rds_password" {
  description = "RDS password for bastion"
  type        = string
  sensitive   = true
}
