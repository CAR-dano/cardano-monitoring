# Secure Access and TLS (Sprint 3)

This document covers issue `#8`.

## Objective

- Expose only Grafana publicly on `monitoring-cardano.inspeksimobil.id`.
- Keep Prometheus, Loki, Jaeger, and OTel Collector internal-only.

## Implemented controls

- Reverse proxy TLS termination on `443`
- HTTP-to-HTTPS redirect on `80`
- Basic auth via `.htpasswd`
- Source IP allowlist (`allowlist.conf`)
- Internal service path blocking (`403`)

## Required operational files

- `deploy/proxy/certs/fullchain.pem`
- `deploy/proxy/certs/privkey.pem`
- `deploy/proxy/auth/.htpasswd`
- `deploy/proxy/allowlist/allowlist.conf`

## Validation commands

```bash
docker compose -f deploy/proxy/docker-compose.proxy.yml config
docker run --rm -v "$PWD/deploy/proxy/nginx.conf:/etc/nginx/nginx.conf:ro" nginx:1.27-alpine nginx -t
```

## Public access checks

1. `http://monitoring-cardano.inspeksimobil.id` redirects to HTTPS.
2. `https://monitoring-cardano.inspeksimobil.id` prompts for auth.
3. Authenticated request serves Grafana.
4. Paths like `/prometheus`, `/loki`, `/jaeger`, `/otel` return `403`.

## Network note

In production, combine proxy controls with firewall/security-group rules so internal service ports are not publicly routable.
