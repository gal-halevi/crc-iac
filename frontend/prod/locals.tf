locals {
  domain_list = var.env == "prod" ? concat([var.domain_name], var.alternate_domains) : []
  config_json = jsonencode({
    apiUrl     = module.be_data.be_outputs.apiUrl
    tableName  = module.be_data.be_outputs.tableName
    primaryKey = module.be_data.be_outputs.primaryKey
  })
}