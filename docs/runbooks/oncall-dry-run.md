# On-Call Dry-Run Procedure

This procedure validates alert routing, triage readiness, and evidence collection.

## Goal

- Verify critical and warning alert flows.
- Confirm runbooks are sufficient for first-response actions.
- Produce evidence artifacts for issue closure.

## Preparation

- Ensure stacks are running:
  - Prometheus + Alertmanager
  - Grafana datasources
  - OTel Collector + Jaeger
- Open dashboards:
  - Platform Overview
  - Service - Cardano Backend

## Dry-run scenarios

### Scenario A: Warning alert route

1. Send synthetic warning alert payload to Alertmanager API.
2. Verify it is routed to warning receiver.
3. Confirm grouping behavior (batched, no excessive repeats).

### Scenario B: Critical alert route

1. Send synthetic critical alert payload.
2. Verify critical receiver path is selected.
3. Confirm delivery timing is faster than warning route.

### Scenario C: Inhibition behavior

1. Fire paired warning + critical with same `alertname/service/env`.
2. Verify warning is inhibited while critical remains active.

### Scenario D: Triage workflow

1. Use `incident-triage.md` checklist end-to-end.
2. Collect one sample trace and related logs.
3. Record decision points and escalation outcome.

## Evidence template

- Dry-run date/time:
- Participants:
- Scenario results:
  - A warning route: pass/fail
  - B critical route: pass/fail
  - C inhibition: pass/fail
  - D triage flow: pass/fail
- Captured artifacts:
  - alert payload samples
  - screenshot links
  - sample trace IDs
  - sample request IDs/log links
- Follow-up actions:

## Sign-off criteria

- All scenarios pass or have tracked follow-up actions.
- Evidence artifacts stored and linked in issue.
- On-call reviewer confirms runbook usability.
