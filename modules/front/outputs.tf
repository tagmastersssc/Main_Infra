output "azurerm_static_web_app_hostname" {
  value = "${var.client}.${var.environment}.${var.main_domain_name}"
}