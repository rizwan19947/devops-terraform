output "public_subnets" {
  value = module.subnets.public_subnets
}

output "private_subnets" {
  value = module.subnets.private_subnets
}

output "rds_endpoint" {
  value = module.rds.db_instance_address
}
