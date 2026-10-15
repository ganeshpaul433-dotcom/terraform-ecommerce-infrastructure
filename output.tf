# Bucket output Configuration

output "bucket_name" {
  description = "Name of the E-Commerce product assets bucket"
  value       = aws_s3_bucket.product_assets.bucket
}

output "bucket_arn" {
  description = "ARN of the E-Commerce product assets bucket"
  value       = aws_s3_bucket.product_assets.arn
}

output "siri_bucket_name" {
  description = "Name of the second S3 bucket"
  value       = aws_s3_bucket.siri_bucket.bucket
}

output "siri_bucket_arn" {
  description = "ARN of the second S3 bucket"
  value       = aws_s3_bucket.siri_bucket.arn
}

output "storage_bucket_names" {
  description = "Names of the dynamic storage buckets, keyed by requirement"
  value       = { for key, bucket in aws_s3_bucket.storage : key => bucket.bucket }
}

output "storage_bucket_arns" {
  description = "ARNs of the dynamic storage buckets, keyed by requirement"
  value       = { for key, bucket in aws_s3_bucket.storage : key => bucket.arn }
}