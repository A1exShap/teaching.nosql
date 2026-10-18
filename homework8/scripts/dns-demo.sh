#!/bin/sh
# =============================================================================
#  dns-demo.sh  —  Classroom DNS exercises
#
#  Run this AFTER the stack is up:  docker compose up --build -d
#  Then:  chmod +x scripts/dns-demo.sh && ./scripts/dns-demo.sh
# =============================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

divider() { echo "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"; }
step()    { echo ""; divider; echo "${BOLD}${YELLOW}▶  $1${RESET}"; divider; }
info()    { echo "   ${CYAN}$1${RESET}"; }
run()     { echo ""; echo "   ${GREEN}\$ $1${RESET}"; eval "$1"; echo ""; }
pause()   { echo ""; printf "   ${BOLD}Press ENTER to continue...${RESET}"; read -r _; }

clear
echo ""
echo "${BOLD}╔══════════════════════════════════════════════════════════════╗${RESET}"
echo "${BOLD}║      HashiCorp Consul — DNS Service Discovery Demo          ║${RESET}"
echo "${BOLD}╚══════════════════════════════════════════════════════════════╝${RESET}"
echo ""
info "This script walks through Consul DNS step-by-step."
info "Each exercise shows a different DNS capability."
echo ""
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 1 — Verify cluster membership"
# ─────────────────────────────────────────────────────────────────────────────
info "First confirm all nodes have joined the cluster."
run "docker exec consul-client-lb consul members"
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 2 — A record: resolve nginx.service.consul"
# ─────────────────────────────────────────────────────────────────────────────
info "An A record query returns the IP of every HEALTHY nginx instance."
info "You should see 3 addresses — one per backend."
run "docker exec netshoot_container dig @consul-client-lb -p 8600 nginx.service.consul"
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 3 — SRV record: get IPs AND ports"
# ─────────────────────────────────────────────────────────────────────────────
info "SRV records include the port number — useful for non-80 services."
run "docker exec netshoot_container dig @consul-client-lb -p 8600 nginx.service.consul SRV +short"
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 4 — Tag-based filtering"
# ─────────────────────────────────────────────────────────────────────────────
info "Consul DNS supports tag prefixes:  <tag>.<service>.service.consul"
info "Our nginx services are tagged 'web' and 'backend'."
run "docker exec netshoot_container dig @consul-client-lb -p 8600 web.nginx.service.consul +short"
run "docker exec netshoot_container dig @consul-client-lb -p 8600 backend.nginx.service.consul +short"
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 5 — Node lookup (node.consul)"
# ─────────────────────────────────────────────────────────────────────────────
info "Every Consul node gets a DNS record under  <node>.node.consul"
run "docker exec netshoot_container dig @consul-client-lb -p 8600 consul-client-1.node.consul"
run "docker exec netshoot_container dig @consul-client-lb -p 8600 consul-server-1.node.consul"
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 6 — Watch the load balancer round-robin"
# ─────────────────────────────────────────────────────────────────────────────
info "The LB at :8080 proxies via nginx.service.consul — no hardcoded IPs."
info "X-Consul-Backend header shows which backend served each request."
echo ""
echo "   ${GREEN}Sending 6 requests to http://localhost:8080 ...${RESET}"
echo ""
for i in $(seq 1 6); do
  backend=$(curl -s -o /dev/null -D - http://localhost:8080 2>/dev/null \
    | grep -i "x-consul-backend" | tr -d '\r' | awk '{print $2}')
  echo "   Request ${i} → ${GREEN}${backend}${RESET}"
done
echo ""
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 7 — Health-check failure removes node from DNS"
# ─────────────────────────────────────────────────────────────────────────────
info "Stop nginx-2. Wait ~15s. Watch it disappear from Consul DNS."
echo ""
echo "   ${RED}Stopping nginx-2...${RESET}"
docker stop nginx-2
echo ""
info "Waiting 15 seconds for health check to fail..."
sleep 15
echo ""
info "DNS query now — nginx-2 (172.20.0.31) should be GONE:"
run "docker exec netshoot_container dig @consul-client-lb -p 8600 nginx.service.consul +short"
echo ""
info "Consul UI Services page: http://localhost:8500/ui/dc1/services/nginx"
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 8 — Node recovers, re-joins DNS automatically"
# ─────────────────────────────────────────────────────────────────────────────
echo "   ${GREEN}Starting nginx-2 again...${RESET}"
docker start nginx-2
echo ""
info "Waiting 15 seconds for health check to pass..."
sleep 15
echo ""
info "DNS query — nginx-2 should be BACK:"
run "docker exec netshoot_container dig @consul-client-lb -p 8600 nginx.service.consul +short"
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 9 — Watch consul-template react in real time"
# ─────────────────────────────────────────────────────────────────────────────
info "The rendered upstream config lives in the shared volume."
info "This is what nginx-lb is currently using:"
run "docker exec consul-template-lb cat /output/default.conf"
echo ""
info "Stop nginx-3 and watch the file update (~15s):"
echo "   ${RED}Stopping nginx-3...${RESET}"
docker stop nginx-3
echo ""
info "Waiting 20 seconds..."
sleep 20
echo "   ${GREEN}Upstream config after nginx-3 failure:${RESET}"
run "docker exec consul-template-lb cat /output/default.conf"
echo ""
echo "   ${GREEN}Restarting nginx-3...${RESET}"
docker start nginx-3
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 10 — Datacenter-scoped DNS"
# ─────────────────────────────────────────────────────────────────────────────
info "Consul DNS supports datacenter qualification:"
info "  <service>.service.<datacenter>.consul"
run "docker exec netshoot_container dig @consul-client-lb -p 8600 nginx.service.dc1.consul +short"
pause

# ─────────────────────────────────────────────────────────────────────────────
step "EXERCISE 11 — HTTP API vs DNS (bonus)"
# ─────────────────────────────────────────────────────────────────────────────
info "Same data, different interface — compare DNS to the HTTP API:"
echo ""
echo "   ${CYAN}DNS result:${RESET}"
run "docker exec netshoot_container dig @consul-client-lb -p 8600 nginx.service.consul +short"
echo ""
echo "   ${CYAN}HTTP API result:${RESET}"
curl -s http://localhost:8500/v1/health/service/nginx?passing | \
  python3 -c "
import sys, json
data = json.load(sys.stdin)
for s in data:
  node = s['Node']['Node']
  addr = s['Service']['Address']
  port = s['Service']['Port']
  print(f'   {node}  {addr}:{port}')
" 2>/dev/null || echo "   (install python3 or jq to pretty-print)"
echo ""
pause

divider
echo ""
echo "${BOLD}${GREEN}✅  All exercises complete!${RESET}"
echo ""
echo "   Consul UI     →  http://localhost:8500"
echo "   nginx-lb      →  http://localhost:8080  (round-robins via Consul DNS)"
echo "   nginx-1       →  http://localhost:8081"
echo "   nginx-2       →  http://localhost:8082"
echo "   nginx-3       →  http://localhost:8083"
echo ""
divider
