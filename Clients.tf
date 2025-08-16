
module "Client1" {
  source = "./clients/risk_analysis/Client"
  application                               = "Risk_Analysis"
  location                                  = "eastus2"
  business_unit                             = "Risk_Analysis"
  client                                    = "Client1"
  cognitive_account_sku                     = "S0"
  cognitive_deployment_model_name           = "gpt-5-mini"
  cognitive_deployment_model_version        = "2025-08-07"
  cognitive_deployment_model_api_version    = "2024-12-01-preview"
  cognitive_deployment_sku_name             = "GlobalStandard"
  custom_domain_front                       = var.custom_domain_front
  serviceprincipalbackclients_object_id     = azuread_service_principal.serviceprincipalbackclients.object_id
  serviceprincipalfrontclients_object_id    = azuread_service_principal.serviceprincipalfrontclients.object_id
}

module "Client2" {
  source = "./clients/risk_analysis/Client"
  application                               = "Risk_Analysis"
  location                                  = "eastus2"
  business_unit                             = "Risk_Analysis"
  client                                    = "Client2"
  cognitive_account_sku                     = "S0"
  cognitive_deployment_model_name           = "gpt-5-mini"
  cognitive_deployment_model_version        = "2025-08-07"
  cognitive_deployment_model_api_version    = "2024-12-01-preview"
  cognitive_deployment_sku_name             = "GlobalStandard"
  custom_domain_front                       = var.custom_domain_front
  serviceprincipalbackclients_object_id     = azuread_service_principal.serviceprincipalbackclients.object_id
  serviceprincipalfrontclients_object_id    = azuread_service_principal.serviceprincipalfrontclients.object_id
}