
resource "azurerm_resource_group" "rgback" {
  name     = "rg-${local.name_prefix}-back-${local.name_suffix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "backtorageaccount" {
  name                     = "${lower(var.client)}${local.environment}"
  resource_group_name      = azurerm_resource_group.rgback.name
  location                 = azurerm_resource_group.rgback.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags                      = local.tags
}

resource "azurerm_storage_container" "storagecontainer" {
  name                  = "${lower(var.client)}${local.environment}-flexcontainer"
  storage_account_id    = azurerm_storage_account.backtorageaccount.id
  container_access_type = "private"
}

resource "azurerm_service_plan" "aspback" {
  name                  = "asp-${local.name_prefix}-back-${local.name_suffix}"
  resource_group_name   = azurerm_resource_group.rgback.name
  location              = azurerm_resource_group.rgback.location
  os_type               = "Linux"
  sku_name              = "FC1"
  tags                  = local.tags
  
}

resource "azurerm_function_app_flex_consumption" "functionback" {
  name                       = "${local.name_prefix}-back-${local.name_suffix}"
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

  tags                  = local.tags
}