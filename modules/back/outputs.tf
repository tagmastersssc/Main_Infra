
output "azurerm_function_hostname" {
  value = azurerm_function_app_flex_consumption.functionback.default_hostname
}

output "azurerm_function_custom_domain_verification_id" {
  value = azurerm_function_app_flex_consumption.functionback.custom_domain_verification_id
}
