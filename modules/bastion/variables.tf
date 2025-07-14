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
  type    = string
}
variable "rds_user" {
  type    = string
}
variable "rds_password" {
  type    = string
}
