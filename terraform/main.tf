terraform {
  required_providers {
    fastly = {
      source = "fastly/fastly"
      version = ">= 0.40.0"
    }
  }
}

# You MUST have a FASTLY_API_KEY environmental variable for this to work 

resource "fastly_service_vcl" "kitsunegay_fastly_vcl" {
    name = "Kitsune.gay"
    activate = true
    default_ttl = 3600  
    
    stale_if_error = true
    stale_if_error_ttl = 43200
    

    dynamic "backend" {
        for_each = var.backends
        content {
          name = backend.value["name"]
          address = backend.value["address"]
          weight = backend.value["weight"]
          auto_loadbalance = backend.value["auto_loadbalance"]
          shield = backend.value["shield"]
          ssl_check_cert = backend.value["ssl_check_cert"]
        }
        
    }

    dynamic "condition" {
    for_each = var.conditions

    content {
      name = condition.value["name"]
      priority = condition.value["priority"]
      statement = condition.value["statement"]
      type = condition.value["type"]

    }
  }
      # You were last checking here

  dictionary {
      name = var.redirects
      write_only = false
    }

  
  dictionary {
    name = var.sitemap_main
  }
  
  dictionary {
    name = var.sitemap_writing_stories
  }
  

  domain {
      comment = ""
      name = "www.kitsune.gay"
    }
    domain {
      comment = "Getting the base domain up"
      name = "kitsune.gay"
    }

    gzip {
      content_types = var.gzip_contenttypes
      extensions = var.gzip_extensions
      name = "Generated by default gzip policy"
    }

    # dynamic "healthcheck" {
    #   for_each = var.healthchecks
    
    # content {
    #     host = healthcheck.value["host"]
    #     name = healthcheck.value["name"]
    #     path = healthcheck.value["path"]
    # }
    # }

    dynamic "header" {
      for_each = var.headers

      content  {
        name = header.value["name"]
        destination = header.value ["destination"]
        action = header.value["action"]
        request_condition = header.value["request_condition"]
        response_condition = header.value["response_condition"]
        source = header.value["source"]
        type = header.value ["type"]
        ignore_if_set = header.value["ignore_if_set"]
        priority = header.value["priority"]
      }
    }

    logging_honeycomb {
      dataset = "myDataset"
      format = "{\n    \"time\":\"%%{begin:%Y-%m-%dT%H:%M:%SZ}t\",\n    \"data\":  {\n      \"service_id\":\"%%{req.service_id}V\",\n      \"time_elapsed\":%D,\n      \"request\":\"%m\",\n      \"host\":\"%%{if(req.http.Fastly-Orig-Host, req.http.Fastly-Orig-Host, req.http.Host)}V\",\n      \"url\":\"%%{cstr_escape(req.url)}V\",\n      \"protocol\":\"%H\",\n      \"is_ipv6\":%%{if(req.is_ipv6, \"true\", \"false\")}V,\n      \"is_tls\":%%{if(req.is_ssl, \"true\", \"false\")}V,\n      \"is_h2\":%%{if(fastly_info.is_h2, \"true\", \"false\")}V,\n      \"client_ip\":\"%h\",\n      \"geo_city\":\"%%{client.geo.city.utf8}V\",\n      \"geo_country_code\":\"%%{client.geo.country_code}V\",\n      \"server_datacenter\":\"%%{server.datacenter}V\",\n      \"request_referer\":\"%%{Referer}i\",\n      \"request_user_agent\":\"%%{User-Agent}i\",\n      \"request_accept_content\":\"%%{Accept}i\",\n      \"request_accept_language\":\"%%{Accept-Language}i\",\n      \"request_accept_charset\":\"%%{Accept-Charset}i\",\n      \"cache_status\":\"%%{regsub(fastly_info.state, \"^(HIT-(SYNTH)|(HITPASS|HIT|MISS|PASS|ERROR|PIPE)).*\", \"\\\\2\\\\3\") }V\",\n      \"status\":\"%s\",\n      \"content_type\":\"%%{Content-Type}o\",\n      \"req_header_size\":%%{req.header_bytes_read}V,\n      \"req_body_size\":%%{req.body_bytes_read}V,\n      \"resp_header_size\":%%{resp.header_bytes_written}V,\n      \"resp_body_size\":%%{resp.body_bytes_written}V\n    }\n  }"
      format_version = 2
      name = "Honeycomb Logging"
      token = var.honeycomb_pass
      # Okay so this works but there are better solutions
    }
    
    
    request_setting {
      action = ""
      bypass_busy_wait = false
      default_host = ""
      force_miss = false
      force_ssl = true
      hash_keys = ""
      max_stale_age = 0
      name = "Generated by force TLS and enable HSTS"
      request_condition = ""
      timer_support = false
      xff = ""
    }
    dynamic "response_object" {
      for_each = var.response_objects
      content {
        cache_condition = response_object.value["cache_condition"]
        content = response_object.value["content"]
        content_type = response_object.value["content_type"]
        name = response_object.value["name"]
        request_condition = response_object.value["request_condition"]
        response = response_object.value["response"]
        status = response_object.value["status"]
      }
      
    }

    dynamic "snippet" {
      for_each = var.snippets
      content  {
        content = snippet.value["content"]
        name = snippet.value["name"]
        type = snippet.value["type"]
        priority = snippet.value["priority"]
      }
    }

    
    vcl {
      content = local.content
      main = var.main_vcl["main"]
      name = var.main_vcl["name"]
    }
    # Change this when we actually do this

}

resource "fastly_service_dictionary_items" "kitsunegay_fastly_vcl_dictionary" {
  
  
  for_each = {
    for d in fastly_service_vcl.kitsunegay_fastly_vcl.dictionary : d.name => d if d.name == var.redirects
  }
  service_id = fastly_service_vcl.kitsunegay_fastly_vcl.id
  dictionary_id = each.value.dictionary_id
  manage_items  = true
  items = {
    "/alexandria" : "https://www.notion.so/vixenlibrary/Who-is-Alexandria-cc34a3d079e347c585b085364958949c"
    "/ellen" : "https://vixenlibrary.notion.site/Who-Is-Ellen-4fcfe4ea5dde416cbaaa473adbaa3893"
    "/jade" : "https://vixenlibrary.notion.site/Who-is-Jade-57161a4effa54e0da77802dbf6f118a4"
    "/lily" : "https://vixenlibrary.notion.site/Who-Is-Lily-34eac034cea24a519fd41519ec0298aa"
    "/mars" : "https://kitsunemars.herokuapp.com/"
    "/sc" : "https://vixenlibrary.notion.site/Who-is-SC-6f5875496b4f45fabe9ab7d93b386056"
    "/serena" : "https://vixenlibrary.notion.site/Who-Is-Serena-f4d6390451094a16b0bebaf791419ff9"
    "/status" : "https://www.notion.so/vixenlibrary/Kitsune-Status-3aa4b832776a4e76bb23cf7dcc80df38"
    "/system" : "http://vixenlibrary.notion.site/Unity-System-af6ace30d5e5426faeb369703e07ea6c"
    "/taptaptap" : "https://youtu.be/YB7KjE1XRw8"
    "/ashfur" : "https://youtu.be/0MIcmD_-Jvg"
    "/maddie" : "https://youtu.be/_hjRvZYkAgA?t=422"

  }
}

resource "fastly_service_dictionary_items" "kitsunegay_sitemap_main_vcl_dictionary" {
  
  
  for_each = {
    for d in fastly_service_vcl.kitsunegay_fastly_vcl.dictionary : d.name => d if d.name == var.sitemap_main
  }
  service_id = fastly_service_vcl.kitsunegay_fastly_vcl.id
  dictionary_id = each.value.dictionary_id
  manage_items  = true
  items = {
    "/main": "www.kitsune.gay",
    "/writing.html": "www.kitsune.gay",
    "/blog.html": "www.kitsune.gay",
    "/presentations.html": "www.kitsune.gay",
    #sitemap writing starts here
    "/schedule.html": "www.kitsune.gay",
    "/cast.html": "www.kitsune.gay",
    "/": "www.kitsune.gay",
    "/index.html": "www.kitsune.gay"
  }
}

resource "fastly_service_dictionary_items" "kitsunegay_sitemap_writings_main_vcl_dictionary" {
  
  
  for_each = {
    for d in fastly_service_vcl.kitsunegay_fastly_vcl.dictionary : d.name => d if d.name == var.sitemap_writing_stories
  }
  service_id = fastly_service_vcl.kitsunegay_fastly_vcl.id
  dictionary_id = each.value.dictionary_id
  manage_items  = true
  items = {
    "/writings/losingapack.html": "www.kitsune.gay/writings",
    "/writings/shelaytheredying.html": "www.kitsune.gay/writings",
    "/writings/oldfriends.html": "www.kitsune.gay/writings",
    "/writings/electionnight.html":"www.kitsune.gay/writings",
    "/writings/lookatmenow.html": "www.kitsune.gay/writings",
    "/writings/fussywolfpatientvamp.html": "www.kitsune.gay/writings",
    "/writings/sailorscouts.html": "www.kitsune.gay/writings",
    "/writings/vaccination.html": "www.kitsune.gay/writings",
    "/writings/ihavetroubletrustingyoumotherfuckers.html": "www.kitsune.gay/writings",
    "/writings/anotherfuckingtherapyappointment.html": "www.kitsune.gay/writings"
  }
}


locals {
  content = "${file("${path.module}/kitsune_gay.vcl")}"
}