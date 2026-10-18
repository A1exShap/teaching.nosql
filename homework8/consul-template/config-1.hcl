# =============================================================================
#  consul-template configuration — Node 1
# =============================================================================

consul {
  address = "172.32.0.20:8500"

  retry {
    enabled  = true
    attempts = 12
    backoff  = "250ms"
  }
}

log_level = "info"

# Watch the nginx KV subtree and re-render when anything changes
template {
  source      = "/templates/index.html.tpl"
  destination = "/output/index.html"

  # Pass the node identity into the template via env vars
  # (consul-template exposes them via the `env` function)
  
  # Re-render on every change — no reload command needed because
  # nginx serves files directly from the shared volume.
  wait {
    min = "2s"
    max = "10s"
  }
}
