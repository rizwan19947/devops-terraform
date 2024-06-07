provider "aws" {
  region = var.region
}

variable "availability_zones" {
  description = "List of Availability Zones to distribute the subnets across"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "vpc" {
  source = "./vpc"
}

module "subnets" {
  source = "./subnets"
  vpc_id = module.vpc.vpc_id
  availability_zones = var.availability_zones
}

module "nat_gateway" {
  source = "./nat_gateway"
  public_subnets = module.subnets.public_subnets
}

module "route_tables" {
  source = "./route_tables"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.subnets.public_subnets
  private_subnets = module.subnets.private_subnets
  nat_gateway_id = module.nat_gateway.nat_gateway_id
}

module "security_groups" {
  source = "./security_groups"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./ec2"
  public_subnets = module.subnets.public_subnets
  private_subnets = module.subnets.private_subnets
  frontend_lb_sg_id = module.security_groups.frontend_lb_sg_id
  backend_lb_sg_id = module.security_groups.backend_lb_sg_id
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source = "./rds"
  private_subnets = module.subnets.private_subnets
  rds_sg_id = module.security_groups.rds_sg_id
}