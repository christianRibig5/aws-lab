output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the created VPC"
}

output "public_subnet_ids" {

  value       = [for s in aws_subnet.public : s.id]
  description = "List of the IDs of the created public subnets"
}

output "private_subnet_ids" {
  value       = [for s in aws_subnet.private : s.id]
  description = "List of the IDs of the private subnets"
}

output "public_subnet_map" {
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
  description = "The map of AZ to public subnet ID"

}
