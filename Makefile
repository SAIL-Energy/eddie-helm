RELEASE_NAME?=eddie
NAMESPACE?=hardening

template:
	helm template ./eddie-chart \
	--values ./eddie-chart/values.yaml \
	--values ./eddie-chart/values-$(NAMESPACE).yaml \
	--debug --output-dir ./out

template-plain-chart:
	helm template ./eddie-chart \
	--values ./eddie-chart/values.yaml \
	--debug --output-dir ./out

install:
	helm install $(RELEASE_NAME) -n $(NAMESPACE) \
	--values ./eddie-chart/values.yaml \
	--values ./eddie-chart/values-$(NAMESPACE).yaml \
	--set kafka.replicaCount=0 \
	--set core.replicaCount=0 \
	--set exampleApp.replicaCount=0 \
	--set emqx.replicaCount=0 \
	--set postgres.replicaCount=0 \
	./eddie-chart

remove:
	helm uninstall -n $(NAMESPACE) $(RELEASE_NAME)

standby:
	helm upgrade -n $(NAMESPACE) $(RELEASE_NAME) \
	--values ./eddie-chart/values.yaml \
	--values ./eddie-chart/values-$(NAMESPACE).yaml \
	--set kafka.replicaCount=0 \
	--set core.replicaCount=0 \
	--set exampleApp.replicaCount=0 \
	--set emqx.replicaCount=0 \
	--set postgres.replicaCount=0 \
	./eddie-chart

upgrade:
	helm upgrade -n $(NAMESPACE) $(RELEASE_NAME) \
	--values ./eddie-chart/values.yaml \
	--values ./eddie-chart/values-$(NAMESPACE).yaml \
	./eddie-chart

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
	  --docker-username=${CR_USERNAME} \
	  --docker-password=${CR_PAT}

create-fingrid-jks-secret:
	kubectl -n $(NAMESPACE) create secret generic fingrid-jks --from-file $(FILE_LOCATION)

create-aansluiting-jks-secret:
	kubectl -n $(NAMESPACE) create secret generic aansluiting-jks --from-file $(FILE_LOCATION)

create-ssl-stores-secret:
	kubectl -n $(NAMESPACE) create secret generic kafka-ssl-stores \
	--from-file=kafka.keystore.jks=$(KEYSTORE_LOCATION) \
	--from-file=kafka.truststore.jks=$(TRUSTSTORE_LOCATION)

create-kafka-truststore-secret:
	kubectl -n $(NAMESPACE) create secret generic kafka-server-truststore --from-file $(FILE_LOCATION)

seal-secret:
	yq eval '.$(VALUE)' ./eddie-chart/values-$(NAMESPACE).yaml | tr -d '\n'| kubeseal \
			--controller-namespace $(NAMESPACE) \
			--controller-name sealed-secrets-controller-$(NAMESPACE) \
			--raw \
			--namespace $(NAMESPACE) \
			--name $(RELEASE_NAME)-$(SECRET_NAME) | \
			xargs \-I{} yq eval -i '.$(VALUE) = "{}"' \
			./eddie-chart/values-$(NAMESPACE).yaml
