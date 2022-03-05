# terraform {
#   experiments = [module_variable_optional_attrs]
# }

variable "backends" {
    type = list(object({
        name = string
        address = string
        weight = number
        auto_loadbalance = bool
        shield = string
        ssl_check_cert = bool
    }))
    
#    and thus ends our escapade with default values. I want to point out here for future reference that the reason this didn't work was because of object types and how default works. The way to get it to work would be to use the Defaults() option, but that would require more knowledge about types. Come back and fix this later. There is a way and you can figure it out. 
}

variable "conditions" {
    type = list(object({
        name = string
        statement = string
        type = string
        priority = string
    }))
}


variable "gzip_contenttypes" {
    type = list(string)
    default = ["text/html"]
}

variable "gzip_extensions"{
    type = list(string)
    default = ["html"]
}


variable "headers" {
    type=list(object({
        action = string
        destination = string
        name = string
        type = string
        ignore_if_set = bool
        priority = number
        request_condition = string
        response_condition = string
        source = string
    }))
}

# variable "healthchecks" {
#     type=list(object({
#         host = string
#         name = string
#         path = string
#     }))
# }

variable "honeycomb_pass" {
    description = "The honeycomb password"
    type = string
    sensitive = true
  
}




variable "redirects" {
    type = string
    default = "My Dictionary"
    
}
variable "resourcename" {
  type = string
}
variable "response_objects" { 
    type=list(object({
        cache_condition = string
        content = string
        content_type = string
        name = string
        request_condition = string
        response = string
        status = string
    }))
}

variable "snippets" {
    type=list(object({
        content = string
        name = string
        type = string
        priority = string
    }))

}

# locals { 
# backends = defaults(var.backends, [ {
#       address = "value"
#       name = "value"
#       weight = 60
#     } ]
# )
# }

# it believes it's a tuple 
# https://www.terraform.io/language/functions/defaults
# https://stackoverflow.com/questions/65497709/terraform-experiment-release-module-variable-optional-attrs-variable-with-nes
