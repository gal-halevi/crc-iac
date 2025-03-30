terraform {
  backend "s3" {
    bucket         = "crc-tf-state-bucket-iac-prod"
    key            = "backend.tfstate"
    region         = "us-east-1"
    dynamodb_table = "crc-tf-state-table-prod"
    encrypt        = true
  }
}