output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "bastion_role_arn" {
  description = "IAM Role ARN for Bastion EC2 instance"
  value       = aws_iam_role.bastion_admin_role.arn
}

output "bastion_admin_role_name" {
  description = "IAM Role name for Bastion EC2 instance"
  value       = aws_iam_role.bastion_admin_role.name
}

output "bastion_admin_role_arn" {
  description = "IAM Role ARN for Bastion EC2 instance"
  value       = aws_iam_role.bastion_admin_role.arn
}
