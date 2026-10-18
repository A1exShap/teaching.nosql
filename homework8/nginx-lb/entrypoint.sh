#!/bin/sh
# =============================================================================
#  nginx-lb entrypoint
#
#  1. Waits for consul-template to write the initial default.conf
#  2. Starts nginx in the background
#  3. Watches /etc/nginx/conf.d/ with inotifywait
#  4. On any change: validates the new config, then reloads nginx
#
#  This is the cleanest way to hot-reload nginx from a sidecar because
#  the sidecar (consul-template-lb) only needs to write a file — it does
#  not need shell access or docker exec into this container.
# =============================================================================

set -e

CONFIG_DIR="/etc/nginx/conf.d"
PLACEHOLDER="${CONFIG_DIR}/default.conf"

echo "⏳  [nginx-lb] Waiting for consul-template to write initial upstream config..."

# Write a safe placeholder so nginx can start even before consul-template
# renders the real config.
if [ ! -f "${PLACEHOLDER}" ]; then
  cat > "${PLACEHOLDER}" << 'NGINX_PLACEHOLDER'
# Placeholder — consul-template will replace this shortly.
server {
    listen 8080;
    server_name _;
    location = /health {
        return 200 "nginx-lb starting...\n";
        add_header Content-Type text/plain;
    }
    location / {
        return 503 "consul-template is initializing upstream config...\n";
        add_header Content-Type text/plain;
    }
}
NGINX_PLACEHOLDER
  echo "   Written placeholder config."
fi

echo "🚀  [nginx-lb] Starting nginx..."
nginx -g "daemon off;" &
NGINX_PID=$!
echo "   nginx PID: ${NGINX_PID}"

echo "👀  [nginx-lb] Watching ${CONFIG_DIR} for upstream config changes..."

# inotifywait loop — reloads nginx on every file write
while true; do
  # -e close_write fires when consul-template finishes writing the file
  inotifywait -q -e close_write "${CONFIG_DIR}" 2>/dev/null

  echo "🔄  [nginx-lb] Config change detected — validating..."
  if nginx -t -q 2>/dev/null; then
    echo "✅  [nginx-lb] Config valid — reloading nginx..."
    nginx -s reload
    echo "   Reload sent."
  else
    echo "❌  [nginx-lb] Config invalid — skipping reload. Check consul-template-lb logs."
    nginx -t  # print the error for visibility
  fi
done
