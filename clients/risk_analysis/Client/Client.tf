
module "OpenAI" {
    source                                          = "../../../modules/openai/"
    name_prefix                                     = local.name_prefix
    name_suffix                                     = local.name_suffix
    location                                        = var.location
    environment                                     = local.environment
    client                                          = var.client
    tags                                            = local.tags
    cognitive_account_sku                           = var.cognitive_account_sku
    cognitive_deployment_model_name                 = var.cognitive_deployment_model_name
    cognitive_deployment_model_version              = var.cognitive_deployment_model_version
    cognitive_deployment_sku_name                   = var.cognitive_deployment_sku_name
}

module "Back" {
    source                                          = "../../../modules/back/"
    name_prefix                                     = local.name_prefix
    name_suffix                                     = local.name_suffix
    location                                        = var.location
    environment                                     = local.environment
    client                                          = var.client
    tags                                            = local.tags
    serviceprincipalbackclients_object_id           = var.serviceprincipalbackclients_object_id
    app_settings                                    = {
        SCM_DO_BUILD_DURING_DEPLOYMENT              = "true"
        OpenAIBackend_URL                           = module.OpenAI.azurerm_ai_services_endpoint
        OpenAIBackend_KEY                           = module.OpenAI.azurerm_ai_services_primary_access_key
        OpenAIBackend_MODEL                         = var.cognitive_deployment_model_name
        OpenAIBackend_DEPLOYMENT                    = module.OpenAI.azurerm_cognitive_deployment_model_name
        OpenAIBackend_VERSION                       = var.cognitive_deployment_model_api_version
    }
}

module "Front" {
    source                                          = "../../../modules/front/"
    name_prefix                                     = local.name_prefix
    name_suffix                                     = local.name_suffix
    location                                        = var.location
    environment                                     = local.environment
    client                                          = var.client
    tags                                            = local.tags
    custom_domain_front                             = var.custom_domain_front
    serviceprincipalfrontclients_object_id          = var.serviceprincipalfrontclients_object_id
    app_settings                                    = {
        Backend_URL                                 = module.Back.azurerm_function_hostname
    }
}