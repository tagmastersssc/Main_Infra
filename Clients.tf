
module "Client1" {
  source = "./clients/risk_analysis/Client1"
  application                               = "Risk_Analysis"
  location                                  = "canadaeast"
  business_unit                             = "Risk_Analysis"
  client                                    = "Client1"
  cognitive_account_sku                     = "S0"
  cognitive_deployment_model_name           = "gpt-5"
  cognitive_deployment_model_version        = "0613"
  cognitive_deployment_sku_name             = "Standard"
  custom_domain_front                       = var.custom_domain_front
  serviceprincipalbackclients_object_id     = azuread_service_principal.serviceprincipalbackclients.object_id
  serviceprincipalfrontclients_object_id    = azuread_service_principal.serviceprincipalfrontclients.object_id
}