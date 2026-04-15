
output "azurerm_function_hostname" {
  value = "back.${var.client}.${var.environment}.${var.main_domain_name}"
}