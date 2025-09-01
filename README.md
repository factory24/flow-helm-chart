
# Helm Chart: [Flow Helm Chart]

## Overview

This Helm chart provides a flexible and reusable way to deploy services to Kubernetes. It is designed to be highly configurable and to reduce repetition in your service definitions.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Istio (optional, for advanced networking features)
- Cert-manager (optional, for automated certificate management)

## Installation

To install the Helm chart, use the following command:

```bash
helm install [RELEASE_NAME] flow-helm-chart/flow-helm-chart
```

## Configuration

This chart is configured using the `values.yaml` file. The following sections describe the available configuration options.

### `serviceProperties`

This section defines the default properties for all services deployed with this chart. These properties can be overridden in the specific service sections.

- `name`: The name of the service.
- `namespace`: The namespace to deploy the service to.
- `enabled`: Whether the service is enabled or not.

Example:

```yaml
serviceProperties:
  name: "default-service"
  namespace: "default-namespace"
  enabled: true
```

### Overriding Default Properties

You can override the default properties in the specific service sections. For example, to override the `name` and `namespace` for the `deployment`, you would configure the `deployment` section as follows:

```yaml
deployment:
  name: "my-deployment"
  namespace: "my-namespace"
  # ... other deployment properties
```

If a property is not defined in the specific service section, the value from `serviceProperties` will be used.

### Example `values.yaml`

Here is an example of a `values.yaml` file that deploys a `fraud-service`:

```yaml
serviceProperties:
  name: "fraud-service"
  namespace: "flow"
  enabled: true

deployment:
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
  type: ClusterIP
  ports:
    - port: 8080
      name: http
      targetPort: 8080
      protocol: TCP

configMap:
  enabled: true
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

virtualService:
  enabled: true
  gateways:
    - api-gateway
  httpRoutes:
    - name: fraud-service
      corsPolicy:
        allowHeaders:
          - authorization
          - content-type
        allowOrigins:
          exact: "*"
        allowMethods:
          - GET
          - PUT
          - POST
          - PATCH
          - DELETE
      match:
        - uri:
            prefix: /v1/fraud
      route:
        - destination:
            port:
              number: 8080
  host: api.1flow.org
```


```