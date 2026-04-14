
module "Main_Login" {
  source                       = "./main_login"
  application                  = var.login_application
  location                     = "eastus"
  business_unit                = "Main"
  client                       = var.client
  github_main_back_login_repo  = var.github_main_back_login_repo
  github_main_front_login_repo = var.github_main_front_login_repo
  main_front_url               = azurerm_static_web_app.static_web_app.default_host_name
  static_web_app_sku           = "Free"
  static_web_app_location      = "eastus2"
  main_domain_name             = var.main_domain_name

  default_customer_tenant_id = ""
  tenant_registry_json = jsonencode({
    (module.Client3.tenant_id) = {
      clients_front_url     = module.Client3.front_url
      clients_backend_url   = "https://${module.Client3.back_azurerm_function_hostname}"
      exchange_secret       = module.Client3.client_exchange_secret
      allowed_emails        = local.client3_allowed_emails
      allowed_email_domains = local.client3_allowed_email_domains
    }
  })
}
