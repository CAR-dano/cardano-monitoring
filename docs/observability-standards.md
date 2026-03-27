# Observability Standards v1

This document defines the telemetry consumption standards for the `cardano-monitoring` repository.

## Purpose

- Keep backend instrumentation and monitoring infrastructure aligned.
- Enforce low-cardinality, production-safe dashboards and alerts.

## Inbound telemetry contract

Expected backend producer: `cardano-backend`

Required RED metrics:

- `http_requests_total{service,env,method,route,status_class}`
- `http_request_duration_seconds_bucket{service,env,method,route}`
- `http_request_errors_total{service,env,method,route,error_type}`

Additional metrics currently consumed:

- `application_errors_total{service,env,error_type,route}`
- `active_connections`
- `database_connections_active`

## Label and cardinality policy

Allowed labels:

- `service`
- `env`
- `method`
- `route`
- `status_class`
- `error_type`

Forbidden labels:

- user or account identifiers
- request IDs
- email addresses
- wallet addresses
- tx hashes
- raw query strings

If forbidden labels are detected in incoming telemetry, block panel/rule rollout until fixed in producer instrumentation.

## Route normalization requirement

Dashboards and alerts must aggregate on normalized route templates, not raw paths.

Examples:

- `/api/v1/inspections/:id`
- `/api/v1/inspections/:uuid`
- `/api/v1/blockchain/:hash`

## Metrics scrape baseline

- scrape target: `cardano-backend /api/v1/metrics`
- interval: `15s`
- timeout: `5s`

## Alerting baseline for RED

- Error rate warning: `> 2%` over 5m
- Error rate critical: `> 5%` over 5m
- P95 latency warning: `> 1s`
- P95 latency critical: `> 2s`

## Access and exposure model

- Public entrypoint: `monitoring-cardano.inspeksimobil.id` (Grafana)
- Internal-only components: Prometheus, Loki, Jaeger, OTel Collector
- Enforce controls at reverse proxy and network layer (basic auth and allowlist)

## Versioning

- This standard must be versioned with infra changes.
- Any contract change requires matching updates in backend docs and monitoring configs.
