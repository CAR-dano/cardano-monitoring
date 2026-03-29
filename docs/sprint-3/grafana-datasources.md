# Grafana Datasources Provisioning (Sprint 3)

This document covers issue `#12`: provisioning Grafana datasources as code.

## Provisioned datasources

- Prometheus (`uid=prometheus`) -> `http://prometheus:9090`
- Loki (`uid=loki`) -> `http://loki:3100`
- Jaeger (`uid=jaeger`) -> `http://jaeger:16686`

All are configured as read-only (`editable: false`) and auto-provisioned at startup.

## Files

- `deploy/grafana/docker-compose.grafana.yml`
- `deploy/grafana/grafana.ini`
- `deploy/grafana/provisioning/datasources/datasources.yml`
- `deploy/grafana/validate-datasources.sh`

## Start Grafana

```bash
docker compose -f deploy/grafana/docker-compose.grafana.yml up -d
```

## Verify provisioning and health

Before running validation, ensure Prometheus, Loki, and Jaeger are reachable on the same Docker network topology.

```bash
./deploy/grafana/validate-datasources.sh
```

The script checks:

1. Datasources exist by UID
2. Prometheus datasource health API is `OK`
3. Loki datasource health API is `OK`
4. Jaeger API endpoint is reachable through Grafana proxy

## Security notes

- Keep Grafana behind auth and reverse proxy in shared environments.
- Store admin credentials in deployment secrets, not in repository.
