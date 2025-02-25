terraform {
  backend "s3" {
    bucket         = "crc-tf-state-bucket-iac"
    key            = "frontend.tfstate"
    region         = "us-east-1"
    dynamodb_table = "crc-tf-state"
    encrypt        = true
  }
}