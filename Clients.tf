locals {
  main_login_front_url = lower("https://webapp-main-login-front-${terraform.workspace}-eastus.azurewebsites.net")
  main_login_back_url  = lower("https://webapp-main-login-back-${terraform.workspace}-eastus.azurewebsites.net")

  client3_tenant_id             = "client3"
  client3_allowed_emails        = ["santiagomejia.r02@gmail.com", "smejiar@unbosque.edu.co", "gonzalez915@outlook.com"]
  client3_allowed_email_domains = []
}

resource "random_password" "client3_exchange_secret" {
  length  = 48
  special = false
}

resource "random_password" "client3_session_secret" {
  length  = 64
  special = false
}

module "Client3" {
  source                                 = "./clients/invoice/Client"
  application                            = "Invoice"
  location                               = "centralus"
  business_unit                          = "Invoice"
  client                                 = "Client3"
  sku                                    = "Free"
  custom_domain_front                    = var.custom_domain_front
  serviceprincipalbackclients_object_id  = azuread_service_principal.serviceprincipalbackclientsinvoice.object_id
  serviceprincipalfrontclients_object_id = azuread_service_principal.serviceprincipalfrontclientsinvoice.object_id
  main_login_front_url                   = local.main_login_front_url
  main_login_back_url                    = local.main_login_back_url
  tenant_id                              = local.client3_tenant_id
  tenant_exchange_secret                 = random_password.client3_exchange_secret.result
  client_session_secret                  = random_password.client3_session_secret.result
  cognitive_account_sku                  = "S0"
  cognitive_deployment_model_name        = "gpt-5-nano"
  cognitive_deployment_model_version     = "2025-08-07"
  cognitive_deployment_sku_name          = "GlobalStandard"
}
