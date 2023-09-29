#####################
# Common Data
#####################
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

#####################
# EKS Cluster
#####################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.16.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access       = var.eks_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.eks_cluster_endpoint_public_access_cidrs
  cluster_endpoint_private_access      = var.eks_cluster_endpoint_private_access

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  # control_plane_subnet_ids = module.vpc.intra_subnets
  # vpc_id                   = var.eks_vpc_id
  # subnet_ids               = var.eks_subnet_ids
  # control_plane_subnet_ids = var.eks_control_plane_subnet_ids

  eks_managed_node_groups = {
    main = {
      min_size       = 2
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      platform       = "linux"
    }
  }
  enable_irsa = true

  manage_aws_auth_configmap = true
  aws_auth_roles            = var.eks_aws_auth_roles
  aws_auth_users            = var.eks_aws_auth_users

  tags = var.tags
}

#####################
# VPC
#####################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = join("-", [var.eks_cluster_name, "vpc"])
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 52)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.tags
}



