variable "name_prefix" {}
variable "name_suffix" {}
variable "location" {}
variable "environment" {}
variable "client" {}
variable "tags" {type = map(string)}
variable "custom_domain_front" {}
variable "serviceprincipalfrontclients_object_id" {}
variable "app_settings" {type = map(string)}