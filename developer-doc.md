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

Create EDDIE Config Namespace:
```bash
kubectl create namespace eddie-config
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

Configure Ingress and TLS:
```bash
ingress:
  basePath: "univie"
  host: "eddie-worker.projekte.fh-hagenberg.at"
```

Configure Simulation Region Connector:
```yaml
regionConnectors:
  simulation:
    enabled: "true"
```

Configure ES Datadis:
```yaml
regionConnectors:
  esDatadis:
    enabled: "true"
    encryptedUsername: "AgBBc9AEMeyJLdW0AfGCIgg9Bb8XAMqYUOeC26cQ3ZYZbhuANkhy3JlaLWZJIWmyKx/0ZhBx4z6F3kelnSC2VrN6FnpfmCUw8TeI55wO8GH7fAbX2DHIoQDLSj8q2sbQjs5Rk/t56fxUC1dQ7MRKDLkxeFtjEO1uOsZLj+sElE9MGx2JWIsyiYKMezv84Q2ynLG25DkeQZIkd/zNvrFRItyP3PSKY1ENdBUx/+tZKVmVY3hc4gPjuY/AzHZPqbmhv26ARhJn2lVk55alP9AjMcKmSymPus0iO5QJJYTUh+9ACzYNDs/4F4RYP/wps+fol/Mc2Q7dCA+jc7ww33oPxhKhHxWWPJxBfi1yX4TEav5/7IuwYATeulH63DoK2XDyd2LEtAb1HLE8VwSyGzQDUPn8GEppdIx1+2tLY/gtD12avPKZ6wS4Vo5ZL7qwHUK2WMq79aZepem9o1KaONmc3vMMS/fPK4xOG9NTRYDtZT0lndsJycmaer3UbuoP55/TYluPZhE/5rMZuFoSB3pN/S84T57Ng+3aAfDlU+Od07vYkWdnDJcIxp9MPyaRyRhSOxDRs8x728IjzwoSrDDFjrTgWbS3R+hTNO7JXHi8l+xKkXaQpdmF0KPKC5lRCovQRFTQoH6iLcpWd14n5ehpwIX+dFdDCg4gQkqIOT0EGyDHcDJ/U7anU30oKW0qvKn0s+te4y49l32yAQ=="
    encryptedPassword: "AgBfY6ZKGKvErQhVo+Hbry7jLy+Y/mILjq+FAdBJokV9TiNjntQn+7pdbbxxVTXz0JWoqCEs8g7RIMl2bqdnCJcPvIouF8TpGIN8nrf9gJ8jr+qa/+xo34CPeEhrOEeiNWkDEKwrtIZrSJNHB0WlDKLQKhoNWf0KFCYwE9Zq8GPGzS/iI4jI4sUTF7bKGbIlLuAhwdMFlUSuiJXOl0N8XJfr1+2bh1VoUzNs0PjBihnJu9Eu51tNFyY7a5hmyBk2NI9Ix61NfMCvXGF2ez0o55R1xvw/yOQWKK0SustRwNkM23BzvBu44XWxBDQwsib32n3WXxl41WegwzJCCafRpRWGSNp3ZIwG8qWRHFm+JBCWA5kExOjMNtOTeuWVtUMv7N3GM9S/85wFxGn1ThuLV8N47XQrJVduBEnW3L72CClROFiiCePnjjksj0FTavOlAjNwrof7JISYuvTytFcE6ZwQ0kdZleiUxsW3S35H0giYm2lJl4XvL3rdh7ecxhqQSZIy9eno4zc7JzHaPVjma0D9Y9D3Pj6ja1s2ym7GHz/f0CY9mqvuN1eXvgqfqFddWcN37MkSlLsMYRlO91rH5uOYT6gjp+NFqryKMeZ+riQ/hOcimjahPtGf1Ft/PAVHo9Nn6PFqhwxXxWpDQZD0yypdorqyZ5xYShjoUlCOr0s1y7uuFrHdPLFn13Z24FMYCsQHyu2isMLWRHUVgSM="
    polling: "0 0 17 * * *"
    retry: "0 0 * * * *"
    basePath: "https://datadis.es/"
```