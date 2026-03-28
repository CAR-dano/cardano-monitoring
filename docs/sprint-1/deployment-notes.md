# Sprint 1 Deployment Notes

This note captures the minimum deployment and security conventions for Sprint 1 foundations.

## Topology and exposure

- Public endpoint:
  - `monitoring-cardano.inspeksimobil.id` -> Grafana only
- Internal-only services:
  - Prometheus
  - Alertmanager
  - Loki
  - OpenTelemetry Collector
  - Jaeger

## Network policy baseline

- No direct public ingress to internal components.
- Access to internal observability services only through private network.
- Restrict ingress using allowlist and firewall/security-group rules.

## Reverse proxy baseline

- Terminate TLS at reverse proxy.
- Enforce auth for Grafana entrypoint (basic auth in early phase if SSO not ready).
- Route only Grafana path publicly.
- Do not route `/metrics`, Loki, Jaeger, or Prometheus UI publicly.

## Backend metrics scrape policy

- Scrape endpoint: `cardano-backend /api/v1/metrics`
- Recommended interval: `15s`
- Recommended timeout: `5s`
- Defense in depth:
  - network/proxy restrictions
  - app-layer auth in backend metrics endpoint

## TLS baseline

- HTTPS mandatory for public Grafana endpoint.
- Certificates managed and renewed automatically where possible.

## Rollout checklist

- [ ] DNS resolves to reverse proxy
- [ ] TLS cert valid and not expired
- [ ] Public endpoint only exposes Grafana
- [ ] Internal services unreachable from public internet
- [ ] Auth is enforced on public portal
