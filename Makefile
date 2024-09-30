package:
	helm package flow
	helm repo index .

lint:
	helm lint flow

template:
	helm template flow-helm-chart flow --debug --values flow/values.yaml

bundle:
	make lint
	make template
	make package