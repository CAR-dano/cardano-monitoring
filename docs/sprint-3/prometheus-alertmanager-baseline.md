# Prometheus and Alertmanager Baseline (Sprint 3)

This document covers the baseline deployment for issue `#9`.

## Components

- Prometheus (`9090`)
- Alertmanager (`9093`)
- Baseline alert rules for target health and config reload

## Files

- `deploy/metrics/prometheus.yml`
- `deploy/metrics/rules/baseline-alerts.yml`
- `deploy/metrics/alertmanager.yml`
- `deploy/metrics/docker-compose.metrics.yml`

## Prepare metrics scrape secret

```bash
mkdir -p deploy/metrics/secrets
printf '%s' "<METRICS_BEARER_TOKEN>" > deploy/metrics/secrets/metrics_bearer_token
```

The token must match backend `METRICS_BEARER_TOKEN`.

## Start services

```bash
docker compose -f deploy/metrics/docker-compose.metrics.yml up -d
```

## Validate baseline

1. Validate compose config:

```bash
docker compose -f deploy/metrics/docker-compose.metrics.yml config
```

2. Validate Prometheus config and rules:

```bash
docker run --rm \
  -v "$PWD/deploy/metrics/prometheus.yml:/etc/prometheus/prometheus.yml:ro" \
  -v "$PWD/deploy/metrics/rules:/etc/prometheus/rules:ro" \
  prom/prometheus:v2.55.0 \
  promtool check config /etc/prometheus/prometheus.yml
```

3. Validate Alertmanager config:

```bash
docker run --rm \
  -v "$PWD/deploy/metrics/alertmanager.yml:/etc/alertmanager/alertmanager.yml:ro" \
  prom/alertmanager:v0.27.0 \
  amtool check-config /etc/alertmanager/alertmanager.yml
```

4. Check target health:

- Open Prometheus UI -> Status -> Targets
- Ensure `cardano-backend` target is `UP`

5. Send test alert to Alertmanager:

```bash
curl -X POST http://localhost:9093/api/v2/alerts \
  -H 'Content-Type: application/json' \
  -d '[{"labels":{"alertname":"ManualTestAlert","severity":"warning","service":"cardano-backend"},"annotations":{"summary":"manual test"},"startsAt":"2026-01-01T00:00:00Z"}]'
```

## Security notes

- Keep Prometheus and Alertmanager internal-only in staging/production.
- Never commit bearer token files.
