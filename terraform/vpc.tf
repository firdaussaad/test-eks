data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "eks_vpc"
  cidr               = "10.0.0.0/16"
  azs                = data.aws_availability_zones.available.names
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    terraform   = "true"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/elb"             = 1
  }
}
