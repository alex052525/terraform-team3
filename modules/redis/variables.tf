variable "cluster_name" {
  description = "Project cluster name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where Redis will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for Redis nodes"
  type        = list(string)
}

variable "redis_node_type" {
  description = "Redis instance type"
  type        = string
  default     = "cache.t3.micro"
}
