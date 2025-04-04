data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = "crc-tf-state-bucket-iac-${var.env}"
    key    = "backend.tfstate"
    region = "us-east-1"
  }
}

output "be_outputs" {
  value = data.terraform_remote_state.backend.outputs
}