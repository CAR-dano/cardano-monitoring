# Alert Rules with Environment Tuning (Sprint 4)

This document covers issue `#13`.

## Rule files

- `deploy/metrics/rules/slo-alerts-env.yml`
- `deploy/metrics/rules/platform-alerts-env.yml`

## Included alert classes

- Error rate (warning/critical) by environment
- P95 latency (warning/critical) by environment
- Memory usage (warning/critical) by environment
- Disk free space (warning)
- Service availability (critical)

## Environment thresholds

- Staging uses looser thresholds to reduce noise.
- Production uses stricter thresholds for faster incident response.

## Validation steps

1. Validate Prometheus configuration and rules:

```bash
docker run --rm \
  --entrypoint promtool \
  -v "$PWD/deploy/metrics/prometheus.yml:/etc/prometheus/prometheus.yml:ro" \
  -v "$PWD/deploy/metrics/rules:/etc/prometheus/rules:ro" \
  -v "/tmp/cardano-monitoring-secrets:/etc/prometheus/secrets:ro" \
  prom/prometheus:v2.55.0 \
  check config /etc/prometheus/prometheus.yml
```

2. Synthetic trigger examples:

- Error rate: force repeated 5xx responses.
- Latency: inject delay in backend endpoint.
- Service availability: stop one monitored container briefly.

3. Confirm alert firing in Prometheus and delivery to Alertmanager.

## Runbooks

All alert annotations include a `runbook_url` pointing to:

- `docs/runbooks/alerts.md`
