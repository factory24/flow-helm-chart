
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
  namespace: default
  replicaCount: 1
  restartPolicy: Always
  image:
    repository: athari/billing-service
    tag: latest
    pullPolicy: Never

service:
  name: billing-service
  type: ClusterIP
  namespace: default
  ports:
    - port: 8080
      name: http
      targetPort: 8080
      protocol: TCP

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
  namespace: default
  data: { }

secrets:
  enabled: true
  namespace: default
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
  enabled: true  # Enable the Gateway deployment
  name: my-istio-gateway  # Name for the Gateway resource
  namespace: istio-ingress  # Namespace where the Gateway will be deployed
  specSelector: ingressgateway
  servers:
    - port:
        number: 80
        name: http
        protocol: HTTP
      hosts:
        - "1flow.org"
      tls:
        httpsRedirect: true
    - port:
        number: 443
        name: https
        protocol: HTTPS
      hosts:
        - "1flow.org"
      tls:
        mode: SIMPLE
        credentialName: flow-landing-tls

virtualService:
  enabled: true
  name: billing-service
  host: api.hydrate.local
  namespace: default
  gateway: api-gateway
  routePrefix: /v1/billing
  destinationHost: billing-service.default.svc.cluster.local
  destinationPort: 8080
  healthCheckPath: /health
  allowOrigins:
    exact: "https://1flow.org"
  #    prefix: "/v1"
  #    regex: ""
  allowHeaders:
    - Content-Type
    - Authorization
  allowMethods:
    - GET
    - POST
    - PUT
    - PATCH


```