variable "resourcename" {
  type = string
}

variable "gzip_contenttypes" {
    type = list(string)
    default = ["text/html"]
}

variable "gzip_extensions"{
    type = list(string)
    default = ["html"]
}
variable "backends" {
    type = list(object({
        name = string
        address = string
    }))
}
variable "redirects" {
    type = string
    default = "My Dictionary"
}
variable "headers" {
    type=list(object({
        name = string
        destination = string
        action = string
        request_condition = string
        response_condition = string
        source = string
        type = string
        ignore_if_set = string
        priority = string
    }))
    default = [ {
      action = "value"
      destination = "value"
      name = "value"
      request_condition = ""
      response_condition = ""
      source = ""
      type = "value"
      ignore_if_set = "false"
      priority = "10"
    } ]
#   may have to add a default value
}
variable "conditions" {
    type=list(object({
        name = string
        priority = string
        statement = string
        type = string
    }))
    default = [ {
      name = "value"
      priority = "value"
      statement = "value"
      type = "value"
    } ]
}
variable "healthchecks" {
    type=list(object({
        host = string
        name = string
        path = string
    }))
}
variable "snippets" {
    type=list(object({
        content = string
        name = string
        priority = string
        type = string
    }))
}
variable "honeycomb_pass" {
    description = "The honeycomb password"
    type = string
    sensitive = true
  
}
variable "papertrail_pass" {
    description = "The papertrail password"
    type = string
    sensitive = true
}
#   may have to add a default value