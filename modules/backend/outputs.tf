output "apiUrl" {
  value = module.api_gateway.invoke_url
}

output "tableName" {
  value = "${var.table_name}-${var.env}"
}

output "primaryKey" {
  value = var.primary_key
}