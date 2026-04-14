locals {

  environment = terraform.workspace

  name_prefix = "${var.business_unit}-${var.application}"
  name_suffix = "${terraform.workspace}-${var.location}"

  tags = {
    BU     = var.business_unit
    APP    = var.application
    CLIENT = var.client
    ENV    = terraform.workspace
  }

}
