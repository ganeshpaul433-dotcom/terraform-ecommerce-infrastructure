# 1. Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# 2. Provider Configuration
provider "aws" {
  region = var.aws_region
}

# 3. Resource Configuration
resource "aws_s3_bucket" "product_assets" {
  bucket = local.bucket_name

  tags = {
    Environment = var.environment
    Purpose     = "product-assets"
  }
}

# 4. Resource configuration Second S3 Bucket
resource "aws_s3_bucket" "siri_bucket" {
  bucket = "123-s3-bucket-siri"

  tags = {
    Environment = var.environment
    Purpose     = "siri-bucket"
  }
}

# Resource Dependency
resource "aws_iam_policy" "product_assets_access" {
  name = "${var.project_name}-${var.environment}-product-assets-access"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.product_assets.arn}/*"
      }
    ]
  })
}