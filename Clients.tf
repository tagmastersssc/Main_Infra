
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
  main_login_front_default_hostname      = module.Main_Login.front_azurerm_linux_web_app_hostname
  cognitive_account_sku                  = "S0"
  cognitive_deployment_model_name        = "gpt-5-nano"
  cognitive_deployment_model_version     = "2025-08-07"
  cognitive_deployment_sku_name          = "GlobalStandard"
}