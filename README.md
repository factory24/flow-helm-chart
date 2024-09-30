
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
  name: fraud-service
  namespace: flow
  replicaCount: 1
  restartPolicy: Always
  args: [ ]
  image:
    repository: gfacratharidazwe.azurecr.io/backend/athari-fraud-service
    tag: latest
    pullPolicy: Always
  ports:
    - name: http
      containerPort: 8080
      protocol: TCP

service:
  name: fraud-service
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
  enabled: false
  minReplicas: 1
  maxReplicas: 10

configMap:
  enabled: true
  name: fraud-service
  namespace: flow
  data:
    DB.HOST: "g-pgsql-p-we.postgres.database.azure.com"
    DB.PORT: "5432"
    DB.NAME: "hydrate_aqm_fraud_p_db"
    DB.USER: "hydrate"
    DB.PASS: "ujy5azp.xrn3CMV0get"
    KC.REALM: "hydrate"
    KC.BASE_URL: "https://accounts.hydrate.net/auth"
    EUREKA_ENABLED: "false"
    EUREKA_ZONE_URL: ""
    EUREKA_PREFER_IP: "false"
    EUREKA_REGISTER: "false"
    EUREKA_FETCH_REGISTRY: "false"

secrets:
  enabled: false
  namespace: default
  name: flow
  data: { }

certificate:
  enabled: false
  name: "flow"
  namespace: istio-system
  secretName: "flow"
  issuerRef: letsencrypt
  commonName: dev.everyflow.org
  dnsNames: { }

gateway:
  enabled: false
  name: my-istio-gateway
  namespace: istio-ingress
  specSelector: ingressgateway
  servers:
    - port:
        number: 80
        name: http
        protocol: http
      hosts:
        - "1flow.org"
    - port:
        number: 443
        name: https
        protocol: https
      hosts:
        - "1flow.org"
      tls:
        mode: SIMPLE
        credentialName: keycloak-tls

virtualService:
  enabled: true
  name: ''
  namespace: prod
  host: "api.1flow.org"
  httpRoutes: { }
  tcpRoutes: { }

destinationRule:
  enabled: true
  name: ''
  namespace: ''
  host: ''
  trafficPolicy: { }
  portLevelSettings: { }
  subsets: { }

persistentVolume:
  enabled: false
  name: ''
  namespace: default
  labelType: ''
  storage:
    className: 'default'
    capacity: '10Gi'
  accessModes:
    - ReadWriteOnce
  hostPath: '/mnt/data'

persistentVolumeClaim:
  name: ''
  namespace: default
  enabled: false
  accessModes:
    - ReadWriteOnce
  storage: 16Gi

cronJob:
  enabled: false
  name: ''
  namespace: ''
  schedule: "59 23 28-31 * *"
  restartPolicy: OnFailure
  containers:
    - name: hello
      image: busybox:1.28
      imagePullPolicy: IfNotPresent
      command:
        - /bin/sh
        - -c
        - date; echo Hello from the Kubernetes cluster


argocd:
  name: 'flow'
  enabled: true
  namespace: 'flow'
  projectName: 'flow-production'
  sources: [ ]
  sync:
    automated:
      prune: 'true'
      selfHeal: 'true'
    options:
      - RespectIgnoreDifferences=true
      - PruneLast=true
      - Validate=false
      - ServerSideApply=true
      - ApplyOutOfSyncOnly=true
      - CreateNamespace=true
    retry:
      limit: '2'
      backoffDuration: '5s'
      backOffMaxDuration: '3m0s'
      backOffFactor: '2'
  destination:
    name: ''
    namespace: 'flow'
    server: 'https://kubernetes.default.svc'
  repository:
    url: 'https://factory24.github.io/flow-helm-chart/'
    path: ''
    targetRevision: '0.1.12'
    chart: 'flow-helm-chart'
    valueFiles:
      - values.yaml
  values: { }


```