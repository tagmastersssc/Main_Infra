
module "Back" {
  source                                = "../../../modules/back/"
  name_prefix                           = local.name_prefix
  name_suffix                           = local.name_suffix
  location                              = var.location
  environment                           = local.environment
  client                                = var.client
  tags                                  = local.tags
  serviceprincipalbackclients_object_id = var.serviceprincipalbackclients_object_id
  app_settings = {
    OPENAI_ENDPOINT              = "${module.OpenAI.azurerm_ai_services_endpoint}/openai/v1"
    OPENAI_KEY                   = module.OpenAI.azurerm_ai_services_primary_access_key
    OPENAI_DEPLOYMENT_MODEL_NAME = module.OpenAI.azurerm_cognitive_deployment_model_name
    MAIN_LOGIN_BACK_URL          = var.main_login_back_url
    BILAI_TENANT_ID              = local.tenant_id
    BILAI_TENANT_EXCHANGE_SECRET = var.tenant_exchange_secret
    CLIENTS_FRONT_URL            = "https://${module.Front.azurerm_static_web_app_hostname}"
    CLIENTS_SESSION_SECRET       = var.client_session_secret
    CLIENTS_SESSION_TTL_SECONDS  = "28800"
    SESSION_COOKIE_NAME          = "bilai_client_session"
    SESSION_COOKIE_DOMAIN        = ""
    SESSION_COOKIE_PATH          = "/"
    SESSION_COOKIE_SAMESITE      = "none"
    SESSION_COOKIE_SECURE        = "true"
    VITE_LOGIN_APP_URL           = var.main_login_front_url
    VITE_API_URL                 = "/api"
    VITE_APP_TENANT_ID           = local.tenant_id
    ALLOWED_ORIGINS              = "https://${module.Front.azurerm_static_web_app_hostname}"
    RAW_API_BASE_URL             = ""
    RAW_API_KEY                  = ""
    RAW_API_KEY_IN_HEADER        = "false"
    RAW_API_KEY_HEADER_NAME      = "x-functions-key"
    RAW_API_TIMEOUT_SECONDS      = "15"
  }
  cors_allowed_origins = ["https://${module.Front.azurerm_static_web_app_hostname}"]
}

module "Front" {
  source                                 = "../../../modules/front/"
  name_prefix                            = local.name_prefix
  name_suffix                            = local.name_suffix
  location                               = var.location
  environment                            = local.environment
  client                                 = var.client
  tags                                   = local.tags
  sku                                    = var.sku
  serviceprincipalfrontclients_object_id = var.serviceprincipalfrontclients_object_id
  main_login_front_default_hostname      = replace(var.main_login_front_url, "https://", "")
  backend_api_url                        = local.client_back_api_url
  runtime_config_url                     = local.client_runtime_config_url
  tenant_id                              = local.tenant_id
}

module "TableStorage" {
  source                                = "../../../modules/tablestorage/"
  name_prefix                           = local.name_prefix
  name_suffix                           = local.name_suffix
  location                              = var.location
  environment                           = local.environment
  client                                = var.client
  tags                                  = local.tags
  serviceprincipalbackclients_object_id = var.serviceprincipalbackclients_object_id
}

module "OpenAI" {
  source                             = "../../../modules/openai/"
  name_prefix                        = local.name_prefix
  name_suffix                        = local.name_suffix
  location                           = var.location
  environment                        = local.environment
  client                             = var.client
  tags                               = local.tags
  cognitive_account_sku              = var.cognitive_account_sku
  cognitive_deployment_model_name    = var.cognitive_deployment_model_name
  cognitive_deployment_model_version = var.cognitive_deployment_model_version
  cognitive_deployment_sku_name      = var.cognitive_deployment_sku_name

}
