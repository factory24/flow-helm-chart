
# Helm Chart: [Flow Helm Chart]

## Overview

This Helm chart provides [brief description of the application or service being deployed].

## Prerequisites

- [List any prerequisites or dependencies required before deploying the Helm chart]

## Installation

To install the Helm chart, use the following command:

```bash
helm install card-service flow-helm-chart
```

```yaml
deployment:
  name: billing-service
  replicaCount: 1
  restartPolicy: Always
  image:
    repository: athari/billing-service
    tag: latest
    pullPolicy: Never

service:
  name: billing-service
  type: ClusterIP
  port: 8080
  targetPort: 8080

resources:
  enabled: true
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 100

configMap:
  enabled: true
  name: billing-service
  data: { }

secrets:
  enabled: true
  name: flow
  data: { }

certificate:
  enabled: true
  name: "flow"
  namespace: istio-system
  secretName: "flow"
  issuerRef: letsencrypt
  commonName: dev.everyflow.org
  dnsNames: { }

gateway:
  enabled: true
  name: "flow"
  namespace: istio-system
  specSelector: ingressgateway
  servers:
    - port:
        number: 80
        name: http
        protocol: http
      hosts:
        - "dev.everyflow.org"
      tls:
        httpsRedirect: false

virtualService:
  enabled: true
  name: billing-service
  host: api.hydrate.local
  gateway: api-gateway
  routePrefix: /v1/billing
  destinationHost: billing-service.default.svc.cluster.local
  destinationPort: 8080
  healthCheckPath: /health
  allowOrigins:
    - exact: "*"
  allowHeaders:
    - Content-Type
    - Authorization
  allowMethods:
    - GET
    - POST
    - PUT
    - PATCH
```