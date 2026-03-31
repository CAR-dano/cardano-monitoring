# Reliability Controls: Retention and Backup Strategy (Sprint 5)

This document covers issue `#16`.

## Retention controls

### Prometheus

- `--storage.tsdb.retention.time=${PROMETHEUS_RETENTION_TIME:-15d}`
- `--storage.tsdb.retention.size=${PROMETHEUS_RETENTION_SIZE:-20GB}`

### Alertmanager

- `--data.retention=${ALERTMANAGER_RETENTION_TIME:-120h}`

These are configured in `deploy/metrics/docker-compose.metrics.yml`.

## Backup scripts

### Grafana

- Backup: `deploy/grafana/backup-grafana.sh`
- Restore: `deploy/grafana/restore-grafana.sh`

Backs up:

- provisioned datasources and dashboards
- Grafana persistent volume snapshot (`grafana-data.tar.gz`)

### Prometheus and Alertmanager

- Backup: `deploy/metrics/backup-prometheus-alertmanager.sh`
- Restore: `deploy/metrics/restore-prometheus-alertmanager.sh`

Backs up:

- `prometheus.yml`, `alertmanager.yml`, rules folder
- Prometheus TSDB and Alertmanager data volumes (best effort)

## Backup test procedure

1. Run backup scripts for Grafana and metrics stack.
2. Record generated backup directory timestamp.
3. Modify one dashboard/rule/config file deliberately.
4. Run corresponding restore script with the backup directory.
5. Restart services and verify restored state.

## Operational guidance

- Schedule daily config backups and periodic data backups.
- Store backups in external object storage (encrypted, versioned).
- Test restore at least monthly in staging.
