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
  value = local.portal_domain != "" ? "https://${local.portal_domain}" : "https://${module.Front.azurerm_static_web_app_hostname}"
}

output "back_url" {
  value = local.client_back_origin
}
