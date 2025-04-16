
module "OpenAI" {
    source              = "../../../modules/openai/"
    name_prefix         = local.name_prefix
    name_suffix         = local.name_suffix
    location            = var.location
    environment         = local.environment
    client              = var.client
    tags                = local.tags
}