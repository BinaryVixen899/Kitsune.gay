resourcename = "kitsunegay_fastly_vcl"


backends = [
    {
        "name" = "Tail1"
        "address" = "www.kitsune.gay.s3-website-us-west-1.amazonaws.com"
    },
    {
        "name" = "Tail2"
        "address" = "www.kitsune.gay1.s3-website-us-west-1.amazonaws.com"
    },
    {
        "name" = "Tail3"
        "address" = "www.kitsune.gay2.s3-website-us-west-1.amazonaws.com"
    }
]

conditions = [
    {
        "name" = "Generated by synthetic response for 404 page"
        "priority" = "0"
        "statement" = "beresp.status == 404"
        "type" = "CACHE"

    },
    {
        "name" = "Generated by synthetic response for 503 page"
        "priority" = "0"
        "statement" = "beresp.status == 503"
        "type" = "CACHE"

    },
    {
        "name" = "If /"
        "priority" = "0"
        "statement" = "req.url.path ~ \"^/$\""
        "type" = "CACHE"
    },

    {
        "name" = "Purge"
        "priority" = 10
        "statement" = "req.request == \"FASTLYPURGE\""
        "type" = "REQUEST"
    },
    {
        "name" = "Sneps"
        "priority" = 10
        "statement" = "req.http.snep ~ \"true\""
        "type" = "RESPONSE"
    },
    {
        "name": "snep",
        "priority": 10,
        "statement": "if req.http.snep",
        "type": "REQUEST"
    }        
]

headers = [
    {
        "destination" = "http.Fastly-Purge-Requires-Auth"
        "name" = "Fastly Purge"
        "action" = "set"
        "request_condition" = "Purge"
        "type" = "response"
        "source" = "\"1\""
        
    },

    {
        "destination" = "http.Surrogate-Key"
        "name" = "Surrogate Keys"
        "action" = "set"
        "type" = "cache"
        "source" = "regsub(req.url, \"^/(.*)\\.(.*)$\", \"\\1\")"
    },

    {
        "destination" = "http.Strict-Transport-Security"
        "name" = "Generated by force TLS and enable HSTS"
        "priority" = "100"
        "source" = "\"max-age=300\""
        "type" = "response"
    },

    {
        "destination" = "http.homph"
        "name" = "Snow Leopards"
        "action" = "set"
        "response_condition" = "Sneps"
        "source" = "\"mow\""
        "type" = "response"
    }
  
]
    #   action = 
    #   name = 
    #   destination = 
    #   type = 


gzip_contenttypes = [
    "application/javascript",
    "application/json",
    "application/vnd.ms-fontobject",
    "application/x-font-opentype",
    "application/x-font-truetype",
    "application/x-font-ttf",
    "application/x-javascript",
    "application/xml",
    "font/eot",
    "font/opentype",
    "font/otf",
    "image/svg+xml",
    "image/vnd.microsoft.icon",
    "text/css",
    "text/html",
    "text/javascript",
    "text/plain",
    "text/xml"
]
gzip_extensions = [
      "css",
      "eot",
      "html",
      "ico",
      "js",
      "json",
      "otf",
      "svg",
      "ttf"
]


healthchecks = [
    {
        host = "http://www.kitsune.gay1.s3-website-us-west-1.amazonaws.com/"
        name = "Kitsune.Gay 1 Healthcheck"
        path = "/www.kitsune.gay1-healthcheck.txt"
    },
    {
        host = "www.kitsune.gay"
        name = "S3Healthcheck"
        path = "/www.kitsune.gay-healthcheck.txt"

    },
    {
        host = "www.kitsune.gay2.s3-website-us-west-1.amazonaws.com"
        name = "Kitsune.Gay2"
        path = "/www.kitsune.gay2-healthcheck.txt"

    }
]