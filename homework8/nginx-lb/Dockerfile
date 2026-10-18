# =============================================================================
#  nginx-lb image
#  Extends the official nginx:alpine image with inotify-tools so the
#  entrypoint can watch /etc/nginx/conf.d/ for changes written by the
#  consul-template-lb sidecar and hot-reload nginx automatically.
# =============================================================================
FROM nginx:alpine

RUN apk add --no-cache inotify-tools

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
