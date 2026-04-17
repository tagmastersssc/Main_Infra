
output "azurerm_function_hostname" {
  # value = "back.${var.client}.${var.environment}.${var.main_domain_name}"
  value = azurerm_function_app_flex_consumption.functionback.default_hostname
}