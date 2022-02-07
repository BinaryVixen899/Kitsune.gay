terraform {
  experiments = [module_variable_optional_attrs]
}

variable "backends" {
    type = list(object({
        name = string
        address = string
        shield = optional(string)
        ssl_check_cert = optional(bool)
        weight = optional(number)
    }))
    default = [ {
        name = "required"
        address = "required"
        shield = "pao-ca-us"
        ssl_check_cert = true
        # UHHHH, check this out 
        weight = 100
    }]
}
variable "conditions" {
    type=list(object({
        name = string
        statement = string
        type = string
        priority = optional(string)
        
        
    }))
    default = [ {
      name = "value"
      statement = "value"
      type = "value"
      priority = "10"
    } ]
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
        ignore_if_set = optional(bool)
        priority = optional(number)
        request_condition = optional(string)
        response_condition = optional(string)
        source = optional(string)
    }))
    default = [ {
      action = "required"
      destination = "required"
      name = "required"
      type = "required"
      ignore_if_set = true
      priority = 10
      request_condition = "Purge"
    } ]
}

variable "healthchecks" {
    type=list(object({
        host = string
        name = string
        path = string
    }))
}

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
        priority = optional(string)
    }))
    default = [{
        content = "required"
        name = "required"
        type = "required"
        priority = "100"
    }]
}


#   may have to add a default value