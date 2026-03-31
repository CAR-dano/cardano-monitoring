# cardano-monitoring

Monitoring and observability infrastructure for Cardano backend services.

## Stack layout

- `deploy/metrics` -> Prometheus + Alertmanager
- `deploy/logs` -> Loki + Promtail
- `deploy/otel` -> OTel Collector + Jaeger
- `deploy/grafana` -> Grafana provisioning and dashboards
- `deploy/proxy` -> reverse proxy entrypoint

## Quick start (fresh clone)

1. Copy environment template:

```bash
cp .env.example .env
```

2. Create Prometheus scrape token file:

```bash
mkdir -p deploy/metrics/secrets
printf '%s' "<METRICS_BEARER_TOKEN>" > deploy/metrics/secrets/metrics_bearer_token
```

3. Start stack components:

```bash
docker compose -f deploy/metrics/docker-compose.metrics.yml up -d
docker compose -f deploy/logs/docker-compose.logs.yml up -d
docker compose -f deploy/otel/docker-compose.otel-jaeger.yml up -d
docker compose -f deploy/grafana/docker-compose.grafana.yml up -d
docker compose -f deploy/proxy/docker-compose.proxy.yml up -d
```

## Verify commands

```bash
docker compose -f deploy/metrics/docker-compose.metrics.yml config
docker compose -f deploy/logs/docker-compose.logs.yml config
docker compose -f deploy/otel/docker-compose.otel-jaeger.yml config
docker compose -f deploy/grafana/docker-compose.grafana.yml config
docker compose -f deploy/proxy/docker-compose.proxy.yml config
```

Health endpoints:

- Prometheus: `http://localhost:9090/-/healthy`
- Alertmanager: `http://localhost:9093/-/healthy`
- Loki: `http://localhost:3100/ready`
- OTel Collector: `http://localhost:13133`
- Jaeger UI: `http://localhost:16686`
- Grafana: `http://localhost:3000/api/health`
- Proxy entrypoint: `https://localhost/`

## Secure exposure model

- Public entrypoint: `monitoring-cardano.inspeksimobil.id` (Grafana only)
- Proxy enforces:
  - HTTPS redirect + TLS termination
  - basic auth
  - IP allowlist
  - explicit block for internal endpoints (Prometheus/Loki/Jaeger/OTel)

See `deploy/proxy/README.md` for required auth and certificate files.

## Notes

- Keep secrets out of git.
- Prefer internal-only exposure for observability components.
