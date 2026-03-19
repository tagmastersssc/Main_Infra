
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
        OPENAI_ENDPOINT                             = "${module.OpenAI.azurerm_ai_services_endpoint}/openai/v1"
        OPENAI_KEY                                  = module.OpenAI.azurerm_ai_services_primary_access_key
        OPENAI_DEPLOYMENT_MODEL_NAME                = module.OpenAI.azurerm_cognitive_deployment_model_name
    }
    cors_allowed_origins                             = ["*"] #["https://portal.azure.com","https://functions.azure.com","".....] cambiar cuando se tenga el dominio
}

module "Front" {
    source                                          = "../../../modules/front/"
    name_prefix                                     = local.name_prefix
    name_suffix                                     = local.name_suffix
    location                                        = var.location
    environment                                     = local.environment
    client                                          = var.client
    tags                                            = local.tags
    sku                                             = var.sku
    custom_domain_front                             = var.custom_domain_front
    serviceprincipalfrontclients_object_id          = var.serviceprincipalfrontclients_object_id
    app_settings                                    = {
        # REACT_APP_BACKEND_URL                       = module.Back.azurerm_function_hostname
    }
    main_login_front_default_hostname               = var.main_login_front_default_hostname
    backend_api_url                                 = module.Back.azurerm_function_hostname
}

module "TableStorage" {
    source                                          = "../../../modules/tablestorage/"
    name_prefix                                     = local.name_prefix
    name_suffix                                     = local.name_suffix
    location                                        = var.location
    environment                                     = local.environment
    client                                          = var.client
    tags                                            = local.tags
    serviceprincipalbackclients_object_id           = var.serviceprincipalbackclients_object_id
}

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