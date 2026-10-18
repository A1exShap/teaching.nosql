#!/bin/sh
# =============================================================================
#  Bootstrap script — seeds the Consul KV store with initial values.
#  consul-template watches these keys and re-renders the nginx pages
#  whenever they change.
# =============================================================================

set -e

CONSUL_ADDR="${CONSUL_HTTP_ADDR:-http://172.20.0.10:8500}"

echo "⏳  Waiting for Consul cluster to be ready at ${CONSUL_ADDR} ..."
until curl -sf "${CONSUL_ADDR}/v1/status/leader" | grep -E '"[0-9.]+:[0-9]+"' > /dev/null 2>&1; do
  echo "   ... not ready yet, retrying in 3s"
  sleep 3
done
echo "✅  Consul cluster is ready."

# ---------------------------------------------------------------------------
# Shared site configuration (rendered into every nginx page)
# ---------------------------------------------------------------------------
consul kv put -http-addr="${CONSUL_ADDR}" nginx/config/site_title    "HashiCorp Consul Demo"
consul kv put -http-addr="${CONSUL_ADDR}" nginx/config/company_name  "Consul Learning Lab"
consul kv put -http-addr="${CONSUL_ADDR}" nginx/config/environment   "Development"
consul kv put -http-addr="${CONSUL_ADDR}" nginx/config/version       "1.0.0"
consul kv put -http-addr="${CONSUL_ADDR}" nginx/config/primary_color "#6C4FBB"   # HashiCorp purple
consul kv put -http-addr="${CONSUL_ADDR}" nginx/config/footer_text   "Powered by HashiCorp Consul + consul-template"

# ---------------------------------------------------------------------------
# Per-node messages (each nginx node reads its own key)
# ---------------------------------------------------------------------------
consul kv put -http-addr="${CONSUL_ADDR}" nginx/nodes/nginx-node-1/message \
  "Hello from Node 1 — I am served via consul-client-1 🟢"

consul kv put -http-addr="${CONSUL_ADDR}" nginx/nodes/nginx-node-2/message \
  "Hello from Node 2 — I am served via consul-client-2 🔵"

consul kv put -http-addr="${CONSUL_ADDR}" nginx/nodes/nginx-node-3/message \
  "Hello from Node 3 — I am served via consul-client-3 🟡"

# ---------------------------------------------------------------------------
# Feature flags (show/hide sections on the page)
# ---------------------------------------------------------------------------
consul kv put -http-addr="${CONSUL_ADDR}" nginx/features/show_cluster_info  "true"
consul kv put -http-addr="${CONSUL_ADDR}" nginx/features/show_kv_explorer   "true"
consul kv put -http-addr="${CONSUL_ADDR}" nginx/features/maintenance_mode   "false"
consul kv put -http-addr="${CONSUL_ADDR}" nginx/features/banner_message     "📚 Welcome! Try changing KV values and watch all pages update in real-time."

# ---------------------------------------------------------------------------
# Demo content block
# ---------------------------------------------------------------------------
consul kv put -http-addr="${CONSUL_ADDR}" nginx/content/hero_heading  "Service Discovery & Configuration Management"
consul kv put -http-addr="${CONSUL_ADDR}" nginx/content/hero_body \
  "This page is dynamically rendered by consul-template reading live values from the Consul KV store. Change any key via the Consul UI at http://localhost:8500 and the pages will update automatically — no redeploy needed."

echo ""
echo "✅  KV store seeded successfully!"
echo ""
echo "📋  Keys written:"
consul kv get -http-addr="${CONSUL_ADDR}" -recurse nginx/ | awk -F: '{printf "   %-55s %s\n", $1, substr($0, index($0,$2))}'
echo ""
echo "🌐  Consul UI  →  http://localhost:8500"
echo "🌐  nginx-1   →  http://localhost:8081"
echo "🌐  nginx-2   →  http://localhost:8082"
echo "🌐  nginx-3   →  http://localhost:8083"
