# EDDIE Helm
This documentation is targeted for EDDIE developers, that are working with EDDIE deployments.
The aim of this documentation is creating a common understanding and showing the steps to create a completely new EDDIE instance.

## What is Helm and why are we using it
Helm is an open-source package manager for Kubernetes.
Helm allows us to create an EDDIE package (package=chart), that can be installed to an Kubernetes cluster by anyone.
The vision behind the eddie chart is, that EPs can install EDDIE (and everything that is required for EDDIE) on their Kubernetes cluster with one single command.
Due to the complexity of EDDIE it is not realistic to install everything with one single command.
Especially, because all sensitive password must be encrypted, so the entire helm values can be tracked in version control.

However, even if EDDIE cannot be installed with a single command this chart allows to install EDDIE to a Kubernetes cluster with very low effort.
Maybe it is even possible to automate the following steps with a script.

## Current Problems
- The plain Kafka image from bitnami lacks in configuration options through environments, therefore not all sensitive parameters can be injected as encrypted environments.   
  As a result the charts require an additional `values` file, that includes the sensitive values and ***must not*** be tracked by version control.  
  This can be fixed either by finding a more sophisticated Kafka image, or by customizing the existing Kafka image.
- Sealed Secrets provides a cli to encrypt secrets, but to make it more comfortable we created the `seal-secret` make target that allows to simply encryt a value from the values file.
  This is achieved using yq, but ***currently it removes all blank files*** from the values file.

## Prerequisites
To work with the eddie helm chart the following tools need to be installed:
- helm
- k3s (minikube might also work, but helm is originally tested in kind -> kubernetes in docker)
- kubeseal
- yq (on arch based go-yq)
- keytool

## Install EDDIE on Kubernetes Cluster
First of all define the NAMESPACE, where the EDDIE instance should be installed (this configuration is also necessary for the make targets):
```bash
export NAMESPACE=mynamespace
```

Create the namespace on the Kubernetes cluster:
```bash
kubectl create namespace $NAMESPACE
```

Create the initial values files, ***all following configurations have to be placed in these 2 files***:
```bash
touch eddie-chart/values-$NAMESPACE.yaml
touch eddie-chart/values-unencrypted-$NAMESPACE.yaml
```

Currently, EDDIE images are stored in a private Container Registry (CR), therefore it is necessary to create a personal access token with the privileges to read images, as described in the [GitHub docs](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).
The created github token has to be stored in a Kubernetes Secret (in each namespace), which can be easily done with the provided Makefile:
```bash
export CR_USERNAME=yourgithubusername
export CR_PAT=your generated pat
make create-ghcr-secret
```

If you have used the make target to create the secret, you can skip this step (because the default value points to your secret), otherwise you have to overwrite the name of the created secret within your values file (`eddie-chart/values-$NAMESPACE.yaml`), as follows:
```yaml
ghcrImagePullSecrets:
  name: "ghcr-secret"
```

If you are planning to install multiple eddie instances on the same cluster (e.g. dev/qa/prod), add this to your values (`eddie-chart/values-$NAMESPACE.yaml`):
```yaml
sealed-secrets:
  namespace: "univie" # Replace univie with your Namespace
  fullnameOverride: "sealed-secrets-controller-univie" # Replace univie with your Namespace
  rbac:
    create: true
    clusterRoleName: "univie-secrets-unsealer" # Replace univie with your Namespace
```

After those basic configurations you can install the helm chart on your cluster.
This installation will only start the container that is necessary to encrypt secrets.
***If this make target is not executed, the following steps will not work properly***.
```bash
make install
```

### Postgres
The first step is configuring postgres, which requires a admin username and password. those values have to be configured in your values file (`eddie-chart/values-$NAMESPACE.yaml`).
```yaml
postgres:
  replicaCount: 1
  encryptedUsername: "your encrypted username in cleartext"
  encryptedPassword: "your encrypted password in cleartext"
```

The plaintext values can then be encrypted, so they can be tracked in version control (***If the SECRET_NAME is changed it will not work***):
```bash
make seal-secret VALUE="postgres.encryptedUsername" SECRET_NAME="postgres-secret"
make seal-secret VALUE="postgres.encryptedPassword" SECRET_NAME="postgres-secret"
```

After executing the make seal commands, you can look into your values file and will see, that your plaintext values have been replaced with encrypted values.
You can now execute an upgrade with the following command and check if everything works properly using your preferred kubernetes manager tool (e.g. k9s).
```bash
make upgrade
```

### Kafka
To enable TLS traffic encryption, Kafka requires certificates for each broker and these certificates have to be signed by a certificate authority.
The kafka-tls directory of this repo includes scripts for creating a very simple root ca and certificates for the brokers.

The passwords for the provided scripts are configured using the `.env` file in the kafka-tls folder.
Configure the following values with your secret passwords and the hostname, where your instance is deployed (otherwise the certificates won't work):
```dotenv
HOSTNAME_FOR_KAFKA=your hostname
KEYSTORE_PASSWORD=keystore password
TRUSTSTORE_PASSWORD=truststore password
```

Then you can create a root CA with the following script. 
The Root CA certificate has to be known by all Kafka Clients and the private key should be backed up.
```bash
./create-root-ca.sh
```

You can then create the keystore and certificate for your broker using the following command:
```bash
./create-broker-keys.sh eddie
```

The Kafka Broker needs access to these files, so you have to create a kubernetes secret with these files (change path according to your location):
```bash
make create-ssl-stores-secret KEYSTORE_LOCATION=kafka-tls/kafka.broker-eddie.keystore.jks TRUSTSTORE_LOCATION=kafka-tls/kafka.broker-eddie.truststore.jks
```

Then you can configure the kafka Values in the `eddie-chart/values-$NAMESPACE.yaml` file and insert the keystore and truststore password from the `.env` file in cleartext:
```yaml
kafka:
  replicaCount: 1
  externalPort: 9095
  sslStores:
    secretName: "kafka-ssl-stores"
    keystore:
      encryptedPassword: "your keystore password"
    truststore:
      encryptedPassword: "your truststore password"
```

Then you can seal these secrets:
```bash
make seal-secret VALUE="kafka.sslStores.keystore.encryptedPassword" SECRET_NAME="kafka-secret"
make seal-secret VALUE="kafka.sslStores.truststore.encryptedPassword" SECRET_NAME="kafka-secret"
```

Additionally, you must set a Kafka Admin password, that will not be encrypted and ***must not be checked in in version control*** in the `eddie-chart/values-unencrypted-$NAMESPACE` file:
```yaml
kafka:
  adminPassword: "your secret password"
# Optional but recommended: overwrite predefined password like this
  users:
    - name: eddie-core
      password: "your secret password for core"
      consumeTopics:
        - name: validated-historical-data
          group: eddie-core
        - name: permission-market-documents
          group: eddie-core
        - name: terminations
          group: termination-group
      produceTopics:
        - name: validated-historical-data
        - name: permission-market-documents
        - name: terminations
        - name: accounting-point-market-documents
        - name: raw-data-in-proprietary-format
        - name: status-messages
    - name: kafka-client
      password: "your secret password for client"
      consumeTopics:
        - name: validated-historical-data
          group: kafka-client-group
        - name: permission-market-documents
          group: kafka-client-group
        - name: terminations
          group: kafka-client-group
        - name: accounting-point-market-documents
          group: kafka-client-group
        - name: raw-data-in-proprietary-format
          group: kafka-client-group
        - name: status-messages
          group: kafka-client-group
          
core:
  kafkaUser:
    username: "eddie-core"
    password: "your secret password for core"
```

Now you can update the release and check if everything went well:
```bash
make upgrade
```

# EDDIE Core
After Postgres and Kafka are up and running, you need to setup EDDIE Core.
First of all, eddie requires an JWT HMAC secret, that can be created with the following command:
```yaml
head -c 32 /dev/urandom | base64
```

This secret has to be configured in the values file as follows:
```yaml
core:
  replicaCount: 1
  encryptedJwtHmacSecret: "the result of the previous command"
```

Since this secret is sensitive information, it has to be encrypted with the following command:
```bash
make seal-secret VALUE="core.encryptedJwtHmacSecret" SECRET_NAME="core-secret"
```

After encrypting the secret you can Upgrade Check if it works properly
```bash
make upgrade
```

## Example App

Configure Example App if you need it (should ***never*** be accessible in public):
```yaml
exampleApp:
  replicaCount: 1
```

Upgrade and Check if it works properly:
```bash
make upgrade
```

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: eddie-letsencrypt-prod # Replace eddie with your release name if it is not eddie (default)  
spec:
  acme:
    email: developers@eddie.energy
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: eddie-letsencrypt-prod # Replace eddie with your release name if it is not eddie (default)  
    solvers:
      - http01:
          ingress:
            class: traefik
```

Configure TLS:
```bash
ingress:
  host: "eddie-demo.projekte.fh-hagenberg.at"
  basePath: "univie"
  tls:
    enabled: true
    clusterIssuer: "letsencrypt-prod"
```

```bash
bcrypt-tool hash password
```

## Admin Console Outbound Connector
```yaml
outboundConnectors:
  adminConsole:
    enabled: "true"
    login:
      enabled: "true"
      username: "admin"
      password: "password encoded in bcrypt"
```

## Simulation Region Connector
```yaml
regionConnectors:
  simulation:
    enabled: "true"
```

## AT EDA Region Connector
```yaml
regionConnectors:
  atEda:
    enabled: "true"
    eligiblePartyId: "EP100129"
    pontonMessenger:
      adapter:
        id: "Fabian-Eddie"
        version: "1.0.0"
      hostname: "eddie.projekte.fh-hagenberg.at"
      apiEndpoint: "http://eddie.projekte.fh-hagenberg.at:8443/api"
      port: "2600"
      folder: "/opt/ponton"
      username: "username in cleartext"
      password: "password in cleartext"
```

```bash
make seal-secret VALUE="regionConnectors.atEda.pontonMessenger.encryptedUsername" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.atEda.pontonMessenger.encryptedPassword" SECRET_NAME="region-connector-secrets"
```

## ES DataDis Region Connector
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


## FR Enedis Region Connector
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

## FI Fingrid Region Connector
Tipp ~ is not working
```bash
make create-fingrid-jks-secret FILE_LOCATION=location to jks store
```
```yaml
regionConnectors:
  fiFingrid:
    enabled: "true"
    apiUrl: "https://dh-fingrid-cert01-b2b.azurewebsites.net/rest/FGR/"
    organisation:
      name: "your organization name"
      encryptedUser: "your ogranization user in plaintext"
    keystore:
      secretName: "fingrid-jks"
      encryptedPassword: "your keystore password in plaintext"
      key:
        encryptedAlias: "the alias of your key in plaintext"
        encryptedPassword: "the password of your key in plaintext"
```
```bash
make seal-secret VALUE="regionConnectors.fiFingrid.organisation.encryptedUser" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.fiFingrid.keystore.encryptedPassword" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.fiFingrid.keystore.key.encryptedAlias" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.fiFingrid.keystore.key.encryptedPassword" SECRET_NAME="region-connector-secrets"
```

## NL Mijn Aansluiting Region Connector
```bash
make create-aansluiting-jks-secret FILE_LOCATION=location to jks store
```
```yaml
regionConnectors:
  nlMijnAansluiting:
    enabled: "true"
    issuerUrl: "https://www.acc.mijnenergiedata.nl/autorisatieregister"
    redirectUrl: "https://eddie.projekte.fh-hagenberg.at/region-connectors/nl-edsn/authorization-callback"
    single:
      encryptedKeyId: "id in plaintext"
      scope: "24_maanden_dagstanden"
      clientId: "eddie-continuous"
    continuous:
      encryptedKeyId: "id in plaintext"
      clientId: "eddie-single"
      scope: "consumption_data"
    keystore:
      secretName: "aansluiting-jks"
      encryptedPassword: "keystore password in plaintext"
      key:
        encryptedAlias: "key alias in plaintext"
        encryptedPassword: "key password in plaintext"
```
```bash
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.single.encryptedKeyId" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.continuous.encryptedKeyId" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.keystore.encryptedPassword" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.keystore.key.encryptedAlias" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.nlMijnAansluiting.keystore.key.encryptedPassword" SECRET_NAME="region-connector-secrets"
```

## US GreenButton Region Connector
```yaml
regionConnectors:
  usGreenButton:
    enabled: "true"
    basePath: "https://utilityapi.com"
    redirectUrl: "http://eddie.projekte.fh-hagenberg.at:5030"
    client:
      encryptedApiToken: "api token in plaintext"
    encryptedWebhookSecret: "webhook secret in plaintext"
    activationBatchSize: "1"
    clients:
      - name: "DEMOUTILITY"
        encryptedId: "id in plaintext"
        encryptedSecret: "secret in plaintext"
```
```bash
make seal-secret VALUE="regionConnectors.usGreenButton.client.encryptedApiToken" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.usGreenButton.encryptedWebhookSecret" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.usGreenButton.clients[0].encryptedId" SECRET_NAME="region-connector-secrets"
make seal-secret VALUE="regionConnectors.usGreenButton.clients[0].encryptedSecret" SECRET_NAME="region-connector-secrets"
```
