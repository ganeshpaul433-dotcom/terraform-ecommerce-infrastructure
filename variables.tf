variable "aws_region" {
  type        = string
  description = "AWS region where resources are created"
  default     = "ap-south-1"
}

variable "project_name" {
  type        = string
  description = "Project name used as a prefix in resource names"
  default     = "ecommerce"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "dev"

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be one of: dev, qa, prod."
  }
}