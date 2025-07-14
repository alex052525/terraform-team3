resource "aws_eks_cluster" "this" {
  name     = "${var.cluster_name}"
  role_arn = var.eks_cluster_role_arn

  version = var.k8s_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

}


resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = [var.node_instance_type]
  disk_size       = var.node_volume_size

    remote_access {
    ec2_ssh_key            = var.private_key_name
    source_security_group_ids = [var.bastion_sg_id]  # 2번 Security Group
  }

  scaling_config {
    desired_size = var.node_desired
    max_size     = var.node_max
    min_size     = var.node_min
  }

  depends_on = [
    aws_eks_cluster.this
  ]
}
