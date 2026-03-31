# Alertmanager Routing, Grouping, and Inhibition (Sprint 4)

This document covers issue `#14`.

## Routing model

- `critical` alerts -> `critical-stdout` receiver
- `warning` alerts -> `warning-stdout` receiver
- `Watchdog` -> `watchdog-stdout` receiver

## Grouping strategy

- `group_by`: `alertname`, `service`, `env`, `team`
- Faster dispatch for critical alerts (`group_wait: 10s`)
- Slower batching for warnings to reduce noise

## Inhibition rules

1. `critical` inhibits matching `warning` alerts for same `alertname/service/env`
2. `ServiceAvailabilityProductionCritical` inhibits `PrometheusTargetDown` in production for same service/env

These reduce duplicate/noisy notifications during major incidents.

## Validation

1. Validate config syntax:

```bash
docker run --rm \
  --entrypoint amtool \
  -v "$PWD/deploy/metrics/alertmanager.yml:/etc/alertmanager/alertmanager.yml:ro" \
  prom/alertmanager:v0.27.0 \
  check-config /etc/alertmanager/alertmanager.yml
```

2. Synthetic route test (warning):

```bash
curl -X POST http://localhost:9093/api/v2/alerts \
  -H 'Content-Type: application/json' \
  -d '[{"labels":{"alertname":"SyntheticWarning","severity":"warning","env":"staging","service":"cardano-backend","team":"backend"},"annotations":{"summary":"warning route test"}}]'
```

3. Synthetic route test (critical):

```bash
curl -X POST http://localhost:9093/api/v2/alerts \
  -H 'Content-Type: application/json' \
  -d '[{"labels":{"alertname":"SyntheticCritical","severity":"critical","env":"staging","service":"cardano-backend","team":"backend"},"annotations":{"summary":"critical route test"}}]'
```

4. Inhibition test:

- Fire matching warning+critical alerts with same `alertname/service/env`
- Confirm warning is inhibited while critical remains active
