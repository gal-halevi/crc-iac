module "backend" {
  source           = "../../modules/backend"
  env              = "prod"
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