locals {
  domain_list = concat([var.domain_name], var.alternate_domains)
  config_json = jsonencode({
    apiUrl     = data.terraform_remote_state.backend.outputs.apiUrl
    tableName  = data.terraform_remote_state.backend.outputs.tableName
    primaryKey = data.terraform_remote_state.backend.outputs.primaryKey
  })
}