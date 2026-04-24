
module "Main_Login" {
  source                       = "./main_login"
  application                  = var.login_application
  location                     = var.location
  business_unit                = var.business_unit
  client                       = var.client
  github_main_back_login_repo  = var.github_main_back_login_repo
  github_main_front_login_repo = var.github_main_front_login_repo
  main_front_url               = "https://${var.application}.${local.environment}.${var.main_domain_name}"
  static_web_app_sku           = "Free"
  static_web_app_location      = "eastus2"
  main_domain_name             = var.main_domain_name

  default_customer_tenant_id   = ""
  tenant_registry_json         = jsonencode({})
  clients_backend_url_template = "https://{tenant_slug}-back-${local.environment}-${var.clients_invoice_location}.azurewebsites.net"
  tenant_exchange_secret       = random_password.clients_invoice_tenant_exchange_secret.result
}
