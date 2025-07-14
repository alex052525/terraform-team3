output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_role_arn" {
  value = var.eks_cluster_role_arn
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

#노드그룹 추가
output "node_group_name" {
  value = aws_eks_node_group.default.node_group_name
}
