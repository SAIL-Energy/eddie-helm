# EDDIE Helm
This is the repository, that holds a helm chart for the deployment of EDDIE using Kubernetes.

## For Developers
You need to install the following tools:
- helm
- kind (minikube might also work, but helm is originally tested in kind -> kubernetes in docker)
- kubeseal
- yq
- keytool


## Install EDDIE on Kubernetes Cluster
Set Namespace as temporary variable in local environment:
```bash
export NAMESPACE=mynamespace
```

Create Namespace:
```bash
kubectl create namespace $NAMESPACE
```

Create initial values file:
```bash
touch eddie-chart/values-$NAMESPACE.yaml
```

Create git pull secret:
Retrieve github access token and set values: CR_USERNAME and CR_PAT
Recommendations regarding hist...
```bash
export CR_USERNAME=yourgithubusername
export CR_PAT=your generated pat
make create-ghcr-secret
```

add secret to values:
```yaml
ghcrImagePullSecrets:
  name: "ghcr-secret"
```

If you are planning to install multiple eddie instances on the same cluster, add this to your values-yaml:
```yaml
sealed-secrets:
  namespace: "univie"
  fullnameOverride: "sealed-secrets-controller-univie"
  rbac:
    create: true
    clusterRoleName: "univie-secrets-unsealer"
```

Install
```bash
make install
```

### Postgres
Create and encrypt postgres and Kafka values
go to values-yournamespace.yaml and create values for:
```yaml
postgres:
  replicaCount: 1
  encryptedUsername: "your encrypted username in cleartext"
  encryptedPassword: "your encrypted password in cleartext"
```
Encrypt the values:
```bash
make seal-secret VALUE="postgres.encryptedUsername" SECRET_NAME="postgres-secret"
make seal-secret VALUE="postgres.encryptedPassword" SECRET_NAME="postgres-secret"
```

Upgrade Check if it works properly
```bash
make upgrade
```

### Kafka
Create self-signed CA:
Edit .env file 
```dotenv
HOSTNAME_FOR_KAFKA=your hostname
KEYSTORE_PASSWORD=keystore password
TRUSTSTORE_PASSWORD=truststore password
```

Create root CA:
```bash
./create-root-ca.sh
```

Store created Files!!!

create kafka secret:
```bash
make create-ssl-stores-secret KEYSTORE_LOCATION=kafka-tls/kafka.broker-0.keystore.jks TRUSTSTORE_LOCATION=kafka-tls/kafka.broker-0.truststore.jks
```

Configure Kafka Values and insert keystore and truststore passwords in cleartext:
```yaml
kafka:
  replicaCount: 1
  externalPort: 9095
  adminPassword: "your admin password"
  sslStores:
    secretName: "kafka-ssl-stores"
    keystore:
      encryptedPassword: "your keystore password"
    truststore:
      encryptedPassword: "your truststore password"
```

Seal Secrets:
```bash
make seal-secret VALUE="kafka.sslStores.keystore.encryptedPassword" SECRET_NAME="kafka-secret"
make seal-secret VALUE="kafka.sslStores.truststore.encryptedPassword" SECRET_NAME="kafka-secret"
```

Upgrade Check if it works properly
```bash
make upgrade
```

If you do not have an JwtHmacSecret create it with:
```yaml
head -c 32 /dev/urandom | base64
```

Configure EDDIE Core:
```yaml
core:
  replicaCount: 1
  encryptedJwtHmacSecret: 
```

Seal Secret:
```bash
make seal-secret VALUE="core.encryptedJwtHmacSecret" SECRET_NAME="core-secret"
```

Upgrade Check if it works properly
```bash
make upgrade
```

Configure Example App
```yaml
exampleApp:
  replicaCount: 1
```

Upgrade Check if it works properly
```bash
make upgrade
```

Configure Ingress:
```bash
ingress:
  basePath: "univie"
  host: "eddie-worker.projekte.fh-hagenberg.at"
```

Create Cluster Issuer:
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: developers@eddie.energy
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
      - http01:
          ingress:
            class: traefik
```

Configure TLS:
```bash
ingress:
  tls: enabled
  clusterIssuer: "letsencrypt-prod"
```

Configure Simulation Region Connector:
```yaml
regionConnectors:
  simulation:
    enabled: "true"
```

## AT EDA
```bash
make seal-secret VALUE="regionConnectors.atEda.pontonMessenger.encryptedUsername" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.atEda.pontonMessenger.encryptedPassword" SECRET_NAME="region-connector-secrets"
```

## ES DataDis
```yaml
regionConnectors:
  esDatadis:
    enabled: "true"
    encryptedUsername: "datadis username"
    encryptedPassword: "datadis password"
    polling: "0 0 17 * * *"
    retry: "0 0 * * * *"
    basePath: "https://datadis.es/"
```
```bash
make seal-secret VALUE="regionConnectors.esDatadis.encryptedUsername" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.esDatadis.encryptedPassword" SECRET_NAME="region-connector-secrets"
```


## FR Enedis
```yaml
regionConnectors:
  esDatadis:
    enabled: "true"
    encryptedUsername: "datadis username"
    encryptedPassword: "datadis password"
    polling: "0 0 17 * * *"
    retry: "0 0 * * * *"
    basePath: "https://datadis.es/"
```
```bash
make seal-secret VALUE="regionConnectors.frEnedis.client.encryptedId" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.frEnedis.client.encryptedSecret" SECRET_NAME="region-connector-secrets"
```

## FI Fingrid
```bash
make create-fingrid-jks-secret FILE_LOCATION=location to jks store
```
```bash
make seal-secret VALUE="regionConnectors.fiFingrid.organisation.encryptedUser" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.fiFingrid.keystore.encryptedPassword" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.fiFingrid.keystore.key.encryptedAlias" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.fiFingrid.keystore.key.encryptedPassword" SECRET_NAME="region-connector-secrets"
```

## NL Mijn Aansluiting
```bash
make create-aansluiting-jks-secret FILE_LOCATION=location to jks store
```
```bash
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.single.encryptedKeyId" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.continuous.encryptedKeyId" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.keystore.encryptedPassword" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.keystore.key.encryptedAlias" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.keystore.key.encryptedPassword" SECRET_NAME="region-connector-secrets"
```

## US GreenButton
```bash
make seal-secret VALUE="regionConnectors.usGreenButton.client.encryptedApiToken" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.usGreenButton.encryptedWebhookSecret" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.usGreenButton.clients[0].encryptedId" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.usGreenButton.clients[0].encryptedSecret" SECRET_NAME="region-connector-secrets"
```
