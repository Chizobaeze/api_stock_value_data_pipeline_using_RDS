terraform {
  backend "s3" {
    bucket = "data-rds-data"
    key    = "infrastructure/chiz-rds.tfstate"
    region = "us-east-1"
  }
}