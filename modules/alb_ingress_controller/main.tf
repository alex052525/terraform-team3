resource "helm_release" "aws_alb_ingress_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  create_namespace = true
  version    = "1.4.4"

  set = [
  {
    name  = "clusterName"
    value = var.cluster_name
  },
  {
    name  = "serviceAccount.create"
    value = "true"
  },
  {
    name  = "region"
    value = "ap-northeast-2"
  },
  {
    name  = "vpcId"
    value = var.vpc_id
  }
]

}
