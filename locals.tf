locals {
  bucket_name = "${var.project_name}-${var.environment}-product-assets-ritisha-02"

  # Phase 5: storage requirements as data
  storage_requirements = {
    logs    = "application-logs"
    backups = "backups"
  }

  # Phase 5: conditional, versioning only in prod
  versioning_enabled = var.environment == "prod"

  # Phase 6: region read from the AWS provider via a data source
  current_region = data.aws_region.current.region
}