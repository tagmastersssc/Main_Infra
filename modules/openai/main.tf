
resource "azurerm_resource_group" "rgbackopenai" {
  name      = "rg-${var.name_prefix}-backopenai-${var.name_suffix}-${var.client}"
  location  = var.location
  tags      = var.tags
}

resource "azurerm_ai_services" "ai_services" {
  name                = "ai-${var.name_prefix}-openai-${var.name_suffix}-${var.client}"
  location            = azurerm_resource_group.rgbackopenai.location
  resource_group_name = azurerm_resource_group.rgbackopenai.name
  sku_name            = var.cognitive_account_sku
  tags                = var.tags
}

resource "azurerm_key_vault" "ai_foundry_kv" {
  name                = "ai_foundry_kv-${var.name_prefix}-openai-${var.name_suffix}-${var.client}"
  location            = azurerm_resource_group.rgbackopenai.location
  resource_group_name = azurerm_resource_group.rgbackopenai.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                 = "standard"
  purge_protection_enabled = true
}

resource "azurerm_ai_foundry" "ai_foundry" {
  name                = "ai_foundry-${var.name_prefix}-openai-${var.name_suffix}-${var.client}"
  location            = azurerm_resource_group.rgbackopenai.location
  resource_group_name = azurerm_resource_group.rgbackopenai.name
  storage_account_id  = azurerm_storage_account.example.id   # Associated storage account
  key_vault_id        = azurerm_key_vault.example.id         # Associated Key Vault

  identity {
    type = "SystemAssigned" # Enable system-assigned managed identity
  }
}

# Create an AI Foundry Project within the AI Foundry service
resource "azurerm_ai_foundry_project" "example" {
  name               = "example"                           # Project name
  location           = azurerm_ai_foundry.example.location # Location from the AI Foundry service
  ai_services_hub_id = azurerm_ai_foundry.example.id       # Associated AI Foundry service

  identity {
    type = "SystemAssigned" # Enable system-assigned managed identity
  }
}

resource "azurerm_cognitive_deployment" "cognitive_deployment" {
  name                 = "cd-${var.name_prefix}-openai-${var.name_suffix}-${var.client}"
  cognitive_account_id = azurerm_ai_services.ai_services.id
  model {
    format  = "OpenAI"
    name    = var.cognitive_deployment_model_name
    version = var.cognitive_deployment_model_version
  }

  sku {
    name = var.cognitive_deployment_sku_name
  }
}