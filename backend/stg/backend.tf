terraform {
  backend "s3" {
    bucket         = "crc-tf-state-bucket-iac-stg"
    key            = "backend.tfstate"
    region         = "us-east-1"
    dynamodb_table = "crc-tf-state-table-stg"
    encrypt        = true
  }
}