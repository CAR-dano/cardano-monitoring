# Incident Triage Runbook

Use this runbook for first response to observability alerts.

## Severity model

- `critical`: active outage or high user impact
- `warning`: degradation risk, limited impact, or early signal

## First 10 minutes checklist

1. Acknowledge alert in Alertmanager.
2. Identify impacted env/service from labels (`env`, `service`, `job`).
3. Open Grafana `Platform Overview` and `Service - Cardano Backend` dashboards.
4. Check error rate, p95 latency, and service availability.
5. Check recent deploy/config changes.

## Triage decision tree

- **Service down (`up==0`)**
  - verify container/process health
  - check network path and dependencies
  - recover service and monitor error budget burn

- **High error rate**
  - identify top failing routes
  - inspect logs by `requestId`/`traceId`
  - inspect Jaeger traces for failing span patterns

- **High latency**
  - compare route p95 and throughput
  - inspect DB spans and dependency timings
  - evaluate resource saturation (memory/disk)

- **Platform resource alerts**
  - memory pressure: identify largest workloads
  - low disk: reclaim space/rotate logs or increase storage

## Escalation and communication

- Escalate immediately if:
  - production critical alert persists >10m
  - multiple services impacted
  - customer-facing downtime confirmed
- Post updates every 15 minutes in incident channel.

## Evidence to capture

- alert payload and timestamps
- dashboard screenshots/panel values
- trace IDs and example request IDs
- mitigation actions and outcome
