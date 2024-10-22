RELEASE_NAME=eddie
NAMESPACE=d4g

template:
	helm template ./eddie-chart --debug --output-dir ./out

install-dry-run:
	helm install $(RELEASE_NAME) ./eddie-chart --dry-run

install:
	helm install $(RELEASE_NAME) -n $(NAMESPACE) ./eddie-chart

remove:
	helm uninstall -n $(NAMESPACE) $(RELEASE_NAME)

upgrade:
	helm upgrade -n $(NAMESPACE) $(RELEASE_NAME) ./eddie-chart

cluster-init:
	kind create cluster --name eddie-cluster

cluster-remove:
	kind delete cluster --name eddie-cluster

postgres-forward:
	kubectl port-forward -n $(NAMESPACE) svc/$(RELEASE_NAME)-postgres 15432:5432

eddie-public-forward:
	kubectl port-forward -n $(NAMESPACE) svc/$(RELEASE_NAME)-core 8333:8080

eddie-example-app-forward:
	kubectl port-forward -n $(NAMESPACE) svc/$(RELEASE_NAME)-example-app 8082:8081

create-ghcr-secret:
	kubectl -n $(NAMESPACE) create secret docker-registry ghcr-secret \
	  --docker-server=ghcr.io \
	  --docker-username=benjaminellmer \
	  --docker-password=${CR_PAT}