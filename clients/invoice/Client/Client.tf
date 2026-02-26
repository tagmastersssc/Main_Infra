
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
    sku                                             = var.sku
    custom_domain_front                             = var.custom_domain_front
    serviceprincipalfrontclients_object_id          = var.serviceprincipalfrontclients_object_id
    app_settings                                    = {
        REACT_APP_BACKEND_URL                       = module.Back.azurerm_function_hostname
    }
    main_login_front_default_hostname               = var.main_login_front_default_hostname
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