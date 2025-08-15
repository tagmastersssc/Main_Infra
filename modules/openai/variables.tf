
variable "name_prefix" {}
variable "name_suffix" {}
variable "location" {}
variable "environment" {}
variable "client" {}
variable "tags" {type = map(string)}
variable "cognitive_account_sku" {}
variable "cognitive_deployment_model_name" {}
variable "cognitive_deployment_model_version" {}
variable "cognitive_deployment_sku_name" {}