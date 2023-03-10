module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "eks-cluster"
  cluster_version = "1.23"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 10
  }

  eks_managed_node_groups = {
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 3

      labels = {
        app = "nodejs"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "development"
  }
}


resource "null_resource" "eksconfig"{
  depends_on = [module.eks]
  provisioner "local-exec" {
    command = "aws eks --region ap-southeast-1 update-kubeconfig --name ${module.eks.cluster_name}"
  }
}