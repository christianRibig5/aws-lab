output "tfstate_bucket_arn" {
  value       = aws_s3_bucket.tfstate_bucket.arn
  description = "ARN of of the terraform remote s3 bucket"
}

output "tfstate_bucket_id" {
  value       = aws_s3_bucket.tfstate_bucket.id
  description = "Bucket ID (same as name) the terraform remote s3 bucket"

}
