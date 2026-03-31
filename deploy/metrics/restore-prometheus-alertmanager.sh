#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <backup-directory>"
  exit 1
fi

BACKUP_DIR="$1"

if [[ ! -d "${BACKUP_DIR}" ]]; then
  echo "Backup directory not found: ${BACKUP_DIR}"
  exit 1
fi

echo "Restoring config files..."
cp "${BACKUP_DIR}/prometheus.yml" ./prometheus.yml
cp "${BACKUP_DIR}/alertmanager.yml" ./alertmanager.yml
rm -rf ./rules
cp -R "${BACKUP_DIR}/rules" ./rules

if [[ -f "${BACKUP_DIR}/prometheus-data.tar.gz" ]]; then
  echo "Restoring Prometheus TSDB volume..."
  docker run --rm \
    -v metrics_prometheus-data:/prometheus \
    -v "$(cd "${BACKUP_DIR}" && pwd):/backup:ro" \
    alpine:3.20 \
    sh -c 'rm -rf /prometheus/* && tar xzf /backup/prometheus-data.tar.gz -C /prometheus'
fi

if [[ -f "${BACKUP_DIR}/alertmanager-data.tar.gz" ]]; then
  echo "Restoring Alertmanager data volume..."
  docker run --rm \
    -v metrics_alertmanager-data:/alertmanager \
    -v "$(cd "${BACKUP_DIR}" && pwd):/backup:ro" \
    alpine:3.20 \
    sh -c 'rm -rf /alertmanager/* && tar xzf /backup/alertmanager-data.tar.gz -C /alertmanager'
fi

echo "Restore completed from ${BACKUP_DIR}"
