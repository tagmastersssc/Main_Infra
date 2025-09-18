
module "Main_Login" {
  source                                 = "./main_login"
  application                            = "Login"
  location                               = "eastus"
  business_unit                          = "Main"
  client                                 = "Client1"
  custom_domain_front                    = var.custom_domain_front
  github_main_back_login_repo            = var.github_main_back_login_repo
  github_main_front_login_repo           = var.github_main_front_login_repo
}