resource "azurerm_resource_group" "rgtablestorage" {
  name     = "rg-${var.name_prefix}-tablestorage-${var.name_suffix}-${var.client}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_role_assignment" "roleassignmenttablestoragelients" {
  scope                = azurerm_resource_group.rgtablestorage.id
  role_definition_name = "Contributor"
  principal_id         = var.serviceprincipalbackclients_object_id
}

resource "azurerm_storage_account" "storagetablestorageaccount" {
  name                     = "st${lower(var.client)}${var.environment}"
  resource_group_name      = azurerm_resource_group.rgtablestorage.name
  location                 = azurerm_resource_group.rgtablestorage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_table" "documentsst" {
  name                 = "Documents"
  storage_account_name = azurerm_storage_account.storagetablestorageaccount.name
}