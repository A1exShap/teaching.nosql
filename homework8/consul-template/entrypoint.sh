#!/bin/sh
# =============================================================================
#  Entrypoint for consul-template sidecar.
#  Waits for the local consul client to be reachable, then starts watching.
# =============================================================================

set -e

CONSUL_ADDR="${CONSUL_HTTP_ADDR:-http://127.0.0.1:8500}"
NODE_NAME="${NODE_NAME:-unknown-node}"

echo "🔧  [${NODE_NAME}] consul-template starting..."
echo "    CONSUL_HTTP_ADDR = ${CONSUL_ADDR}"

echo "⏳  [${NODE_NAME}] Waiting for Consul agent at ${CONSUL_ADDR} ..."
until curl -sf "${CONSUL_ADDR}/v1/agent/self" > /dev/null 2>&1; do
  echo "   ... not ready yet, retrying in 2s"
  sleep 2
done
echo "✅  [${NODE_NAME}] Consul agent is reachable."

echo "🚀  [${NODE_NAME}] Starting consul-template — watching KV store..."

exec consul-template \
  -config=/config/consul-template.hcl \
  -log-level=info
