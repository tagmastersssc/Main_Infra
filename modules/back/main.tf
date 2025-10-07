
resource "azurerm_resource_group" "rgback" {
  name                  = "rg-${var.name_prefix}-back-${var.name_suffix}-${var.client}"
  location              = var.location
  tags                  = var.tags
}

resource "azurerm_storage_account" "backtorageaccount" {
  name                     = "${lower(var.client)}${var.environment}"
  resource_group_name      = azurerm_resource_group.rgback.name
  location                 = azurerm_resource_group.rgback.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags                      = var.tags
}

resource "azurerm_storage_container" "storagecontainer" {
  name                  = "${lower(var.client)}${var.environment}-flexcontainer"
  storage_account_id    = azurerm_storage_account.backtorageaccount.id
  container_access_type = "private"
}

resource "azurerm_service_plan" "aspback" {
  name                  = "asp-${var.name_prefix}-back-${var.name_suffix}-${var.client}"
  resource_group_name   = azurerm_resource_group.rgback.name
  location              = azurerm_resource_group.rgback.location
  os_type               = "Linux"
  sku_name              = "FC1"
  tags                  = var.tags
  
}

resource "azurerm_function_app_flex_consumption" "functionback" {
  name                       = "${var.client}-back-${var.name_suffix}"
  resource_group_name         = azurerm_resource_group.rgback.name
  location                    = azurerm_resource_group.rgback.location
  service_plan_id             = azurerm_service_plan.aspback.id
  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${azurerm_storage_account.backtorageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = azurerm_storage_account.backtorageaccount.primary_access_key
  runtime_version = "3.13"
  runtime_name = "python"

  site_config {
    scm_ip_restriction {
      priority      = "100"
      action        = "Allow"
      service_tag   = "AzureCloud"
      name          = "AzureGitHub"
    }
  }

  app_settings          = var.app_settings
  tags                  = var.tags
}

resource "azurerm_role_assignment" "roleassignmentbackclients" {
  scope                 = azurerm_resource_group.rgback.id
  role_definition_name  = "Contributor"
  principal_id          = var.serviceprincipalbackclients_object_id
}