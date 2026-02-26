
module "Main_Login" {
  source                       = "./main_login"
  application                  = "Login"
  location                     = "eastus"
  business_unit                = "Main"
  client                       = var.client
  custom_domain_front          = var.custom_domain_front
  github_main_back_login_repo  = var.github_main_back_login_repo
  github_main_front_login_repo = var.github_main_front_login_repo
  main_front_url               = azurerm_linux_web_app.webappfront.default_hostname
  borrar                       = module.Client3.front_azurerm_static_web_app_hostname
}