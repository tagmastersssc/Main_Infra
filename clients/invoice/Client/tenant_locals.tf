locals {
  portal_domain                = trimspace(var.portal_domain)
  client_back_default_hostname = lower("${var.client}-back-${local.name_suffix}.azurewebsites.net")
  client_back_hostname         = local.portal_domain != "" ? "api.${local.portal_domain}" : local.client_back_default_hostname
  client_back_origin           = "https://${local.client_back_hostname}"
  client_back_api_url          = "${local.client_back_origin}/api"
  client_runtime_config_url    = "${local.client_back_api_url}/runtime-config.js"
  tenant_id                    = var.tenant_id
}
