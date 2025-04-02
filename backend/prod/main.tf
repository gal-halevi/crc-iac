module "backend" {
  source           = "../../modules/backend"
  env              = "prod"
  source_file_path = var.source_file_path
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