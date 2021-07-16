locals {
  private_subnets = ["172.19.0.0/24"]
  public_subnets  = ["172.19.3.0/24"]
}

data "aws_region" "current" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.1.0"

  name = "${var.name-prefix}-test-vpc"
  cidr = "172.19.0.0/18"

  azs             = ["${data.aws_region.current.name}a"]
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Terratest   = "true"
    Environment = "dev"
  }
}

module "sg-ports" {
  #source = "git::https://github.com/Datatamer/terraform-aws-es.git//modules/es-ports?ref=2.0.0"
  source = "../../modules/es-ports"
}

module "aws-sg" {
  source = "git::git@github.com:Datatamer/terraform-aws-security-groups.git?ref=0.1.0"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = [
    "0.0.0.0/0"
  ]
  egress_cidr_blocks = [
    "0.0.0.0/0"
  ]
  ingress_ports  = module.sg-ports.ingress_ports
  sg_name_prefix = var.name-prefix
}

module "tamr-es-cluster" {
  source      = "../../"
  vpc_id      = module.vpc.vpc_id
  domain_name = format("%s-elasticsearch", var.name-prefix)
  subnet_ids  = [module.vpc.private_subnets[0]]
  # Only needed once per account, so may need to set this to false
  create_new_service_role = false
  linked_service_role     = "data.aws_iam_role.es"
  security_group_ids      = module.aws-sg.security_group_ids
  aws_region              = data.aws_region.current.name
  instance_count          = 1
  ebs_volume_size         = 30
}

## If you don't have this ES Role created yet in your AWS Account, this data source will raise an error.
## To fix the error:
## - comment this data source,
## - in the module tamr-es-cluster:
##     - remove the argument linked_service_role,
##     - update the argument create_new_service_role = true
#####
data "aws_iam_role" "es" {
  name = "AWSServiceRoleForAmazonElasticsearchService"
}
