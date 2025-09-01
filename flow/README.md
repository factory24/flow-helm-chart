# flow-helm-chart

This Helm chart is a general-purpose chart for deploying applications to Kubernetes.

## Usage

To use this chart, you will need to create a `values.yaml` file to override the default values.

Example `values.yaml`:

```yaml
deployment:
  enabled: true
  image:
    repository: my-app
    tag: 1.0.0

service:
  enabled: true
```

Then, you can install the chart with the following command:

```bash
helm install my-release ./flow-helm-chart -f my-values.yaml
```
