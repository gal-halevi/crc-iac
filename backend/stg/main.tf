module "backend" {
  source = "../../modules/backend"
  env    = "stg"
  source_file_path = var.source_file_path
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