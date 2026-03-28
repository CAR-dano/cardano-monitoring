# OTel Collector and Jaeger Deployment (Sprint 3)

This document describes the baseline deployment for issue `#11`.

## Components

- OpenTelemetry Collector (`otel-collector`)
  - OTLP gRPC receiver: `4317`
  - OTLP HTTP receiver: `4318`
  - health endpoint: `13133`
- Jaeger (`jaeger`)
  - UI: `16686`
  - OTLP ingest enabled for collector exporter

## Files

- `deploy/otel/collector-config.yaml`
- `deploy/otel/docker-compose.otel-jaeger.yml`

## Start services

```bash
docker compose -f deploy/otel/docker-compose.otel-jaeger.yml up -d
```

## Validate health

```bash
curl -sf http://localhost:13133
curl -sf http://localhost:16686
```

## Backend integration (staging)

Set backend tracing envs (staging):

- `OTEL_ENABLED=true`
- `OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4318`
- `OTEL_TRACES_SAMPLER=parentbased_traceidratio`
- `OTEL_TRACES_SAMPLER_ARG_STAGING=0.2`

## Acceptance check

1. Start collector and Jaeger.
2. Generate backend requests in staging with tracing enabled.
3. Open Jaeger UI (`http://<host>:16686`).
4. Confirm traces for service `cardano-backend` are visible.

## Security notes

- Do not expose OTLP receiver ports publicly.
- Jaeger UI should remain internal-only or protected behind gateway auth.
