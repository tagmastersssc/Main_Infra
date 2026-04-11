output "front_azurerm_linux_web_app_hostname" {
  value = azurerm_linux_web_app.webappfrontlogin.default_hostname
}

output "back_azurerm_linux_web_app_hostname" {
  value = azurerm_linux_web_app.webappbacklogin.default_hostname
}
