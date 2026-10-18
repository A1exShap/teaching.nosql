# =============================================================================
#  consul-template configuration — nginx-lb sidecar
#
#  Unlike the backend sidecars (which watch KV for page content), this sidecar
#  watches the SERVICE CATALOG for healthy "nginx" instances and renders the
#  nginx upstream block.
#
#  Reload strategy:
#    consul-template writes default.conf into the nginx-lb-conf volume.
#    Both containers share that volume.  The command hook calls curl against
#    nginx-lb's internal /health endpoint to confirm the new config is live —
#    the actual reload is triggered by the nginx-lb entrypoint which uses
#    inotifywait to watch /etc/nginx/conf.d/ for changes.
# =============================================================================

consul {
  address = "172.32.0.23:8500"

  retry {
    enabled  = true
    attempts = 12
    backoff  = "250ms"
  }
}

log_level = "info"

template {
  source      = "/templates/upstream.conf.tpl"
  destination = "/output/default.conf"

  # No command needed — the nginx-lb container watches the volume
  # directory with inotifywait and calls "nginx -s reload" itself.
  # See nginx-lb/entrypoint.sh for details.

  wait {
    min = "3s"
    max = "15s"
  }
}
