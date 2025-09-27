
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
        Backend_URL                                 = module.Back.azurerm_linux_web_app_hostname
    }
}