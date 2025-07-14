variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "team3-eks"
}

variable "eks_cluster_role_arn" {
  description = "IAM role arn for the EKS cluster"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role arn for EKS worker nodes"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the EKS Cluster"
  type        = list(string)
}

variable "k8s_version" {
  description = "Kubernetes Version"
  type        = string
  default     = "1.29"
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.large"
}

variable "node_desired" {
  type    = number
  default = 3
}

variable "node_min" {
  type    = number
  default = 1
}

variable "node_max" {
  type    = number
  default = 4
}

variable "node_volume_size" {
  type    = number
  default = 30
}

variable "bastion_sg_id" {
  type = string
}

variable "private_key_name" {
  type = string
}