locals {

  environment                   = terraform.workspace
  business_unit                 = var.business_unit
  application                   = var.application
  location                      = var.location

  name_prefix                   = "${local.business_unit}-${local.application}"
  name_suffix                   = "${local.environment}-${local.location}"
    
  tags                        = {
  BU      = "${local.name_prefix}_${local.name_suffix}"
  CLIENT  = var.client
  ENV     = local.environment
  }

}   