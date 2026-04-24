output "front_azurerm_static_web_app_hostname" {
  value = module.Front.azurerm_static_web_app_hostname
}

output "back_azurerm_function_hostname" {
  value = module.Back.azurerm_function_hostname
}

output "tenant_id" {
  value = local.tenant_id
}

output "front_url" {
  value = "https://${var.client}.${local.environment}.${var.main_domain_name}"
}

output "client_exchange_secret" {
  value = random_password.client_exchange_secret.result
}