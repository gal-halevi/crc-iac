module "backend" {
  source = "../../modules/backend"
  env    = "stg"
  api_cors_allowed_origins = ["*"]
}

output "apiUrl" {
  value = module.backend.apiUrl
}

output "tableName" {
  value = module.backend.tableName
}

output "primaryKey" {
  value = module.backend.primaryKey
}