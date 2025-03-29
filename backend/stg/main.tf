module "backend" {
  source = "../../modules/backend"
  env    = "stg"
  api_cors_allowed_origins = [""]
}