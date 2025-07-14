data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# vpc
module "vpc" {
  source = "./modules/vpc"

  aws_region = "ap-northeast-2"
  vpc_name   = "team3-vpc"
  vpc_cidr = "192.168.0.0/16"

  availability_zones = [ "ap-northeast-2a", "ap-northeast-2c" ]
  public_subnets_cidr = [ "192.168.1.0/24", "192.168.2.0/24" ]
  private_subnets_cidr = [ "192.168.3.0/24", "192.168.4.0/24" ]
}

#eks
module "eks" {
  source        = "./modules/eks"
  cluster_name  = "fastpick-eks"
  subnet_ids    = module.vpc.private_subnet_ids
  k8s_version   = "1.29"
  bastion_sg_id = module.vpc.bastion_sg_id
  private_key_name = var.private_key_name

  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
}

#bastion
module "bastion" {
  source            = "./modules/bastion"
  ami_id            = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type     = "t3.large"
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.vpc.bastion_sg_id
  key_name          = var.public_key_name
  cluster_name      = module.eks.cluster_name
  private_ip        = "192.168.1.100"
  bastion_iam_role_name = module.iam.bastion_admin_role_name
  rds_host     = module.rds.rds_endpoint         # RDS 모듈에서 나온 엔드포인트
  rds_user     = var.db_username                 # tfvars에서 정의된 사용자명
  rds_password = var.db_password                 # tfvars에서 정의된 비밀번호

  depends_on = [module.eks]
}

module "iam" {
  source       = "./modules/iam"
  cluster_name = "fastpick-eks"
}

# RDS
module "rds" {
  source = "./modules/rds"
  
  project_name           = "team3"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  allowed_security_groups = [
    module.eks.cluster_security_group_id,
    module.vpc.bastion_sg_id
  ]
  
  database_name = var.database_name
  username      = var.db_username
  password      = var.db_password
  
  instance_class = "db.t3.micro"
  allocated_storage = 20
}

# redis
module "redis" {
  source              = "./modules/redis"
  cluster_name        = "redis"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  redis_node_type     = "cache.m5.large"
}

# argocd
module "argocd" {
  source        = "./modules/argocd"
  namespace     = "argocd"
  chart_version = "5.51.6"
  providers = {
    helm = helm.eks
    kubernetes = kubernetes.eks
  }
}
