locals {

  environment = terraform.workspace

  name_prefix = "${var.business_unit}-${var.application}"
  name_suffix = "${local.environment}-${var.location}"

  tags = {
    BU     = var.business_unit
    APP    = var.application
    CLIENT = var.client
    ENV    = local.environment
  }

  # client_back_default_hostname = lower("back.${var.client}.${local.environment}.${var.main_domain_name}")
  client_back_default_hostname = lower("${var.client}-back-${local.name_suffix}.azurewebsites.net")
  client_back_api_url          = "https://${local.client_back_default_hostname}/api"
  client_runtime_config_url    = "https://${local.client_back_default_hostname}/api/runtime-config.js"
  tenant_id                    = var.client

}
