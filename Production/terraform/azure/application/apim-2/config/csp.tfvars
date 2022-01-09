subscription                        = "a4212e99-5f1e-474a-9b81-a689fbb09925"
location                            = "Brazil Southeast"
resource_group_name                 = "RG_API_MANAGEMENT_Brazil_Southeast"
subnet_name                         = "AZ3P-SUBNET-APIM"
application_gateway_subnet_name     = "AZ3P-SUBNET-APIM-APPGW"
subnet_name_components              = "AZ3P-SUBNET-APIM-COMP"
virtual_network_name                = "AZ3P-VNET"
virtual_network_resource_group_name = "Network"
key_vault_name                      = "AZ1P-FDCDT"
key_vault_resource_group_name       = "RG_FrontDoor"
user_identity                       = "AZ3P-IDENTITY-APIM"
dns_value                           = "api.conductor.com.br"
certificate_name                    = "conductor-com-br-2021-2022"
backend_url                         = "https://pierapi-cond.conductor.com.br"
cache_duration                      = "94672800" #3 years
cache_duration_invalid              = "3600"     #1 hour
mimir_url                           = "http://10.57.96.35:8080"
log_level                           = "INFO"
units                               = 3