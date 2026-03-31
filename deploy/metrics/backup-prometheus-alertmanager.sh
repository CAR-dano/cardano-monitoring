#!/usr/bin/env bash
set -euo pipefail

BACKUP_ROOT="${BACKUP_ROOT:-./backups/metrics}"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_DIR="${BACKUP_ROOT}/${STAMP}"

mkdir -p "${OUT_DIR}"

echo "Copying Prometheus and Alertmanager configs..."
cp ./prometheus.yml "${OUT_DIR}/prometheus.yml"
cp ./alertmanager.yml "${OUT_DIR}/alertmanager.yml"
cp -R ./rules "${OUT_DIR}/rules"

echo "Archiving Prometheus TSDB volume (best effort)..."
docker run --rm \
  -v metrics_prometheus-data:/prometheus:ro \
  -v "$(pwd)/${OUT_DIR}:/backup" \
  alpine:3.20 \
  sh -c 'tar czf /backup/prometheus-data.tar.gz -C /prometheus . || true'

echo "Archiving Alertmanager data volume (best effort)..."
docker run --rm \
  -v metrics_alertmanager-data:/alertmanager:ro \
  -v "$(pwd)/${OUT_DIR}:/backup" \
  alpine:3.20 \
  sh -c 'tar czf /backup/alertmanager-data.tar.gz -C /alertmanager . || true'

echo "Backup completed at ${OUT_DIR}"
