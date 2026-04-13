locals {
  main_public_domain      = trimspace(var.main_public_domain)
  main_public_hostname    = local.main_public_domain != "" ? local.main_public_domain : azurerm_linux_web_app.webappfront.default_hostname
  main_login_front_domain = local.main_public_domain != "" ? "login.${local.main_public_domain}" : "webapp-main-login-front-${terraform.workspace}-eastus.azurewebsites.net"
  main_login_back_domain  = local.main_public_domain != "" ? "auth.${local.main_public_domain}" : "webapp-main-login-back-${terraform.workspace}-eastus.azurewebsites.net"
}
