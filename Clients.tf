locals {
  client3_allowed_emails        = ["santiagomejia.r02@gmail.com", "smejiar@unbosque.edu.co", "gonzalez915@outlook.com"]
  client3_allowed_email_domains = []
}

module "Client3" {
  source                                 = "./clients/invoice/Client"
  application                            = "Invoice"
  location                               = "centralus"
  business_unit                          = "Invoice"
  client                                 = "Client3"
  sku                                    = "Free"
  serviceprincipalbackclients_object_id  = azuread_service_principal.serviceprincipalbackclientsinvoice.object_id
  serviceprincipalfrontclients_object_id = azuread_service_principal.serviceprincipalfrontclientsinvoice.object_id
  main_login_front_url                   = "https://${var.login_application}.${local.environment}.${var.main_domain_name}"
  main_login_back_url                    = "https://back.${var.login_application}.${local.environment}.${var.main_domain_name}"
  cognitive_account_sku                  = "S0"
  cognitive_deployment_model_name        = "gpt-5-nano"
  cognitive_deployment_model_version     = "2025-08-07"
  cognitive_deployment_sku_name          = "GlobalStandard"
  main_domain_name                       = var.main_domain_name
}
