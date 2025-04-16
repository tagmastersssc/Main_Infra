
resource "azurerm_resource_group" "rgbackopenai" {
  name      = "rg-${var.name_prefix}-backopenai-${var.name_suffix}-${var.client}"
  location  = var.location
  tags      = var.tags
}

resource "azurerm_cognitive_account" "cognitive_account" {
  name                = "ca-${var.name_prefix}-backopenai-${var.name_suffix}-${var.client}"
  location            = azurerm_resource_group.rgbackopenai.location
  resource_group_name = azurerm_resource_group.rgbackopenai.name
  kind                = "OpenAI"
  sku_name            = "S0"
  tags                = var.tags
}

# resource "azurerm_cognitive_deployment" "cognitive_deployment" {
#   name                 = "example-cd"
#   cognitive_account_id = azurerm_cognitive_account.example.id
#   model {
#     format  = "OpenAI"
#     name    = "text-curie-001"
#     version = "1"
#   }

#   sku {
#     name = "Standard"
#   }
# }