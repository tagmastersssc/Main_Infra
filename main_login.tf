
module "Main_Login" {
  source                       = "./main_login"
  application                  = "Login"
  location                     = "eastus"
  business_unit                = "Main"
  client                       = var.client
  github_main_back_login_repo  = var.github_main_back_login_repo
  github_main_front_login_repo = var.github_main_front_login_repo
  main_front_url               = azurerm_linux_web_app.webappfront.default_hostname
  default_customer_tenant_id   = ""
  tenant_registry_json = jsonencode({
    (module.Client3.tenant_id) = {
      clients_front_url     = module.Client3.front_url
      clients_backend_url   = "https://${module.Client3.back_azurerm_function_hostname}"
      exchange_secret       = random_password.client3_exchange_secret.result
      allowed_emails        = local.client3_allowed_emails
      allowed_email_domains = local.client3_allowed_email_domains
    }
  })
}
