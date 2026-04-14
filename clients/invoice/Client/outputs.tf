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
  value = "https://${module.Front.azurerm_static_web_app_hostname}"
}
