# Sprint 1 Environment Variable Matrix

This matrix defines baseline variables required to operate the monitoring portal and collect telemetry safely.

## cardano-monitoring variables

| Variable | Required | Example | Purpose |
| --- | --- | --- | --- |
| `DOMAIN_MONITORING` | yes | `monitoring-cardano.inspeksimobil.id` | Public Grafana domain |
| `GRAFANA_ADMIN_USER` | yes | `admin` | Grafana admin username |
| `GRAFANA_ADMIN_PASSWORD` | yes | `change-me` | Grafana admin password |
| `BASIC_AUTH_USER` | yes | `monitoring` | Reverse proxy basic auth user |
| `BASIC_AUTH_PASSWORD` | yes | `strong-secret` | Reverse proxy basic auth password |

## cardano-backend variables impacting Sprint 1

| Variable | Required | Example | Purpose |
| --- | --- | --- | --- |
| `OBS_SERVICE_NAME` | yes | `cardano-backend` | Metrics `service` label |
| `OBS_ENV` | yes | `staging` | Metrics `env` label |
| `METRICS_ENABLED` | optional | `true` | Toggle `/api/v1/metrics` endpoint |
| `METRICS_BEARER_TOKEN` | recommended | `<secret>` | App-layer metrics auth (bearer) |
| `METRICS_BASIC_AUTH_USER` | recommended | `metrics` | App-layer metrics auth (basic) |
| `METRICS_BASIC_AUTH_PASSWORD` | recommended | `<secret>` | App-layer metrics auth (basic) |

## Security notes

- In production, metrics auth should always be configured.
- Prefer secret manager or vault-backed injection for all auth credentials.
- Do not commit real credentials in repository.
