# =============================================================================
#  consul-template configuration — Node 2
# =============================================================================

consul {
  address = "172.32.0.21:8500"

  retry {
    enabled  = true
    attempts = 12
    backoff  = "250ms"
  }
}

log_level = "info"

template {
  source      = "/templates/index.html.tpl"
  destination = "/output/index.html"

  wait {
    min = "2s"
    max = "10s"
  }
}
