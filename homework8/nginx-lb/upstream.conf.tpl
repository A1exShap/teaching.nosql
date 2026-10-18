# =============================================================================
#  upstream.conf.tpl  —  rendered by consul-template into nginx-lb's conf.d/
#
#  {{ service "nginx" }} queries Consul for ALL HEALTHY instances of the
#  "nginx" service.  When a backend container is stopped, Consul's health
#  check detects it and removes it from the list within ~10s.
#  consul-template re-renders this file and signals nginx to reload.
#
#  Watch this file update live:
#    docker exec consul-template-lb watch -n2 cat /output/default.conf
# =============================================================================

# ------------------------------------------------------------------
# 1.  UPSTREAM BLOCK — populated from the live Consul service catalog
# ------------------------------------------------------------------
upstream consul_nginx_backends {
    # Round-robin (nginx default). Each healthy backend becomes one line.
    {{ range service "nginx" -}}
    server {{ .Address }}:{{ .Port }};   # {{ .Node }}
    {{ else -}}
    # WARNING: No healthy nginx backends found in Consul right now.
    # Requests will return 503 until at least one backend recovers.
    server 127.0.0.1:1 down;
    {{ end }}
}

# ------------------------------------------------------------------
# 2.  SERVER BLOCK — load-balancer listener on port 8080
# ------------------------------------------------------------------
server {
    listen 8080;
    server_name _;

    # Main proxy — forwards to whichever backends Consul currently knows about
    location / {
        proxy_pass         http://consul_nginx_backends;
        proxy_http_version 1.1;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;

        # These response headers make the round-robin visible in curl / DevTools
        add_header X-Consul-Backend  "$upstream_addr"         always;
        add_header X-Consul-Service  "nginx.service.consul"   always;
        add_header X-Rendered-By     "consul-template"        always;

        proxy_intercept_errors on;
        error_page 502 503 504 @no_backends;
    }

    location @no_backends {
        default_type text/html;
        return 503 "<html><body style='font-family:sans-serif;padding:2rem'>
<h2>No healthy backends</h2>
<p>Consul reports zero healthy <code>nginx</code> service instances.</p>
<p>Restart a backend: <code>docker compose start nginx-1</code></p>
</body></html>";
    }

    # Simple health check endpoint for the LB itself
    location = /health {
        access_log off;
        return 200 "nginx-lb healthy\n";
        add_header Content-Type text/plain;
    }

    # nginx connection stats
    location = /stub_status {
        stub_status;
    }
}
