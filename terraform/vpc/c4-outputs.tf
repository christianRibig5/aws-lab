output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the created VPC"
}

output "public_subnet_ids" {

  value       = module.vpc.public_subnet_ids
  description = "List of the IDs of the created public subnets"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "List of the IDs of the private subnets"
}

output "public_subnet_map" {
  value       = module.vpc.public_subnet_map
  description = "The map of AZ to public subnet ID"

}
