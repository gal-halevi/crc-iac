terraform {
  backend "s3" {
    key     = "frontend.tfstate"
    encrypt = true
  }
}