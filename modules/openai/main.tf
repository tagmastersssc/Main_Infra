
data "azurerm_client_config" "current" {}

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
  lifecycle {
    ignore_changes = [ rai_policy_name ]
  }
}