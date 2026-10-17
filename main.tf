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

# vpc configuration
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "ecommerce-${var.environment}-vpc"
    Environment = var.environment
    Purpose     = "ecommerce-network"
  }
}

# add the subnet with vpc
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "ecommerce-${var.environment}-public-subnet"
    Environment = var.environment
    Purpose     = "ecommerce-public-subnet"
  }
}

# security group 
resource "aws_security_group" "web" {
  name        = "ecommerce-${var.environment}-web-sg"
  description = "Security group for E-Commerce web application"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "ecommerce-${var.environment}-web-sg"
    Environment = var.environment
    Purpose     = "ecommerce-web"
  }
}

# ec2 instance configuration
resource "aws_instance" "web" {
  ami           = "ami-0cede6fe40e6ac719" # replace with YOUR region's AMI ID
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  tags = {
    Name        = "ecommerce-${var.environment}-web"
    Environment = var.environment
    Purpose     = "ecommerce-web"
  }
}

# Phase 5: dynamic storage buckets
resource "aws_s3_bucket" "storage" {
  for_each = local.storage_requirements

  bucket = "${var.project_name}-${var.environment}-${each.value}-ritisha-02"

  tags = {
    Environment = var.environment
    Purpose     = each.key
  }
}

resource "aws_s3_bucket_versioning" "storage" {
  for_each = aws_s3_bucket.storage

  bucket = each.value.id

  versioning_configuration {
    status = local.versioning_enabled ? "Enabled" : "Disabled"
  }
}

data "aws_region" "current" {}