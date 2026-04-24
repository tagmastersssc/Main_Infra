output "front_azurerm_linux_web_app_hostname" {
  value = "${var.application}.${local.environment}.${var.main_domain_name}"
}

output "back_azurerm_linux_web_app_hostname" {
  # value = "back.${var.application}.${local.environment}.${var.main_domain_name}"
  value = azurerm_function_app_flex_consumption.webappbacklogin.default_hostname
}
