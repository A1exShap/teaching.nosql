# =============================================================================
#  consul-template sidecar image
#  Installs curl (for health checks) and runs consul-template.
# =============================================================================
FROM alpine:3.19

ENV CONSUL_TEMPLATE_VERSION=0.42.1

RUN apk add --no-cache curl ca-certificates unzip && \
    curl -fsSL \
      "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" \
      -o /tmp/ct.zip && \
    unzip /tmp/ct.zip -d /usr/local/bin && \
    rm /tmp/ct.zip && \
    chmod +x /usr/local/bin/consul-template

# Default dirs
RUN mkdir -p /config /templates /output

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
