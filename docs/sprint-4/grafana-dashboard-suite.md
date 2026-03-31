# Grafana Dashboard Suite (Sprint 4)

This document covers issue `#15`: platform, service, and business dashboards.

## Provisioned dashboards

- Platform Overview (`uid=cardano-platform-overview`)
  - RED summary cards: error rate, p95 latency, throughput
  - service availability and status class trends
- Service - Cardano Backend (`uid=cardano-service-backend`)
  - endpoint usage, route-level error ratio, p95 by route
  - top error hotspots table
  - drill-down link to log explore
- Business KPIs (`uid=cardano-business-kpis`)
  - wallet operations, application errors, blockchain sync
  - operation rates and top business error categories

## Files

- `deploy/grafana/provisioning/dashboards/dashboards.yml`
- `deploy/grafana/provisioning/dashboards/platform-overview.json`
- `deploy/grafana/provisioning/dashboards/service-cardano-backend.json`
- `deploy/grafana/provisioning/dashboards/business-kpis.json`

## Variable and templating

- Environment variable: `env`
- Service dashboard also supports route template variable: `route`

## Ops questions answered quickly

- Are users currently impacted? (error rate, p95, availability)
- Which route is degrading? (route-level throughput/latency/errors)
- Which business domain is failing most? (error type and route)

## Validation checklist

1. Start Grafana with provisioning mounted.
2. Verify all three dashboards appear under `Cardano Monitoring` folder.
3. Switch `env` variable and confirm panels update.
4. Open explore links to verify logs/traces drill-down path.
