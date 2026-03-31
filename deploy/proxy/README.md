# Reverse proxy security setup

This folder contains the secure public entrypoint configuration.

## Required files

1. TLS certificate files:

- `deploy/proxy/certs/fullchain.pem`
- `deploy/proxy/certs/privkey.pem`

2. Basic auth file:

- `deploy/proxy/auth/.htpasswd`

Create with:

```bash
mkdir -p deploy/proxy/auth
docker run --rm --entrypoint htpasswd httpd:2.4-alpine -Bbn monitoring "<STRONG_PASSWORD>" > deploy/proxy/auth/.htpasswd
```

3. Allowed source CIDRs:

- `deploy/proxy/allowlist/allowlist.conf`

Replace default private CIDRs with your office/VPN egress ranges.

## Security behavior

- HTTP (`:80`) redirects to HTTPS.
- HTTPS (`:443`) serves Grafana only.
- Internal endpoints (`prometheus`, `loki`, `jaeger`, `otel`) are blocked with `403`.
- Access requires both allowlist and basic auth.
