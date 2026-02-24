output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnets
}

output "private_subnets" {
  value = module.network.private_subnets
}

# alb dns endpoint
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
