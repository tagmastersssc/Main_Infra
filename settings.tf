locals {

  environment   = terraform.workspace
  business_unit = var.business_unit
  application   = var.application
  location      = var.location

  name_prefix = "${local.business_unit}-${local.application}"
  name_suffix = "${local.environment}-${local.location}"

  tags = {
    BU     = var.business_unit
    APP    = var.application
    CLIENT = var.client
    ENV    = local.environment
  }

  client_back_default_hostname = lower("${var.client}-back-${local.name_suffix}.azurewebsites.net")
  client_back_api_url          = "https://${local.client_back_default_hostname}/api"
  client_runtime_config_url    = "https://${local.client_back_default_hostname}/api/runtime-config.js"
  tenant_id                    = var.client

}
