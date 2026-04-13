output "azurerm_static_web_app_hostname" {
  value = azurerm_static_web_app.static_web_app.default_host_name
}

output "custom_domain_validation_token" {
  value = try(azurerm_static_web_app_custom_domain.custom_domain[0].validation_token, null)
}
