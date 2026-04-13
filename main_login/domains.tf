locals {
  login_front_default_hostname = "webapp-${local.name_prefix}-front-${local.name_suffix}.azurewebsites.net"
  login_back_default_hostname  = "webapp-${local.name_prefix}-back-${local.name_suffix}.azurewebsites.net"
  login_front_hostname         = trimspace(var.front_custom_domain) != "" ? trimspace(var.front_custom_domain) : local.login_front_default_hostname
  login_back_hostname          = trimspace(var.back_custom_domain) != "" ? trimspace(var.back_custom_domain) : local.login_back_default_hostname
  login_front_sku_name         = trimspace(var.front_custom_domain) != "" ? "B1" : "F1"
  login_back_sku_name          = trimspace(var.back_custom_domain) != "" ? "B1" : "F1"
}
