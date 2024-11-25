# EDDIE Partner Deployment User Documentation
Dear Partners,  
for the development of demonstrator applications we (FH) will provide a dedicated EDDIE instance for each partner.
***Please note, that the partner deployment is currently in an experimental phase.***
If you are experiencing any issues, please create Bug Tickets in our [GitHub project](https://github.com/eddie-energy/eddie-helm/issues/new?assignees=&labels=bug&projects=&template=bug.md&title=).
When you received this documentation, your developer accounts should already have permission to create Bugs, otherwise please contact us.

## Fundamentals
Each EDDIE instance currently consists of the following components:
- EDDIE Core
- EDDIE Example App
- Kafka
- Postgres

### EDDIE Core
As the name suggests, EDDIE Core contains the major logic of the EDDIE framework. 
It includes the region connectors and outbound connectors.
The retrieved data from region-connectors is written to Kafka.
Your EDDIE Core instances are currently hosted on the following urls:
- University Vienna: `https://eddie-worker.projekte.fh-hagenberg.at/univie/eddie`
- Digital4Grids: `https://eddie-worker.projekte.fh-hagenberg.at/d4g/eddie`
- Flexidao: `https://eddie-worker.projekte.fh-hagenberg.at/flexidao/eddie`
- Eta+: `https://eddie-worker.projekte.fh-hagenberg.at/etaplus/eddie`

This value should be configured in your EDDIE Connect Button as the `eddieUrl`.  
To manage your connections your can access the Admin Console on the following urls:
- University Vienna: `https://eddie-worker.projekte.fh-hagenberg.at/univie/eddie/outbound-connectors/admin-console`
- Digital4Grids: `https://eddie-worker.projekte.fh-hagenberg.at/d4g/eddie/outbound-connectors/admin-console`
- Flexidao: `https://eddie-worker.projekte.fh-hagenberg.at/flexidao/eddie/outbound-connectors/admin-console`
- Eta+: `https://eddie-worker.projekte.fh-hagenberg.at/etaplus/eddie/outbound-connectors/admin-console`

#### Data Needs
Your EDDIE Core instance is preconfigured with a set of data needs. If you want to create additional Data Needs, please use our API at `your-eddie-url/data-needs/management`.
You can find an extensive documentation for creating data needs in our [documentation](https://eddie-web.projekte.fh-hagenberg.at/framework/1-running/OPERATION.html#data-need-configuration) (swagger is currently disabled on the deployed instances, please use other http tools to creat data needs).
For instance, you could use the following curl command to create a data-need:
```http request
curl -X POST your-eddie-url/data-needs/management \
-H "Content-Type: application/json" \
-d '{
  "type": "validated",
  "policyLink": "https://example.com/toc",
  "name": "My awesome data need",
  "description": "This is a description",
  "purpose": "A text explaining the purpose of this data need.",
  "duration": {
    "type": "relativeDuration"
  },
  "energyType": "ELECTRICITY",
  "minGranularity": "PT15M",
  "maxGranularity": "P1D",
  "regionConnectorFilter": {
    "type": "allowlist",
    "regionConnectorIds": [
      "at-eda"
    ]
  }
}'
```

### EDDIE Example App
The EDDIE Example App is a very simplistic application, that provides you a configured EDDIE Button to test the Framework.
You can log in with the preconfigured account: 
```
username: testuser@example.com
password: testuser@example.com
```
The example app is hosted at the following urls:
- University Vienna: `https://eddie-worker.projekte.fh-hagenberg.at/univie/example-app`
- Digital4Grids: `https://eddie-worker.projekte.fh-hagenberg.at/d4g/example-app`
- Flexidao: `https://eddie-worker.projekte.fh-hagenberg.at/flexidao/example-app`
- Eta+: `https://eddie-worker.projekte.fh-hagenberg.at/etaplus/example-app`

### Kafka
Currently, the deployment contains one single Kafka Broker for each instance.
The Kafka Broker is running in KRaft mode and external communication is secured with SASL_SSL.
Therefore, communication is encrypted, and you need an account for authentication to access data.
Furthermore, we are using a self-signed certificate for SSL, which means you need to trust our self-signed certificate manually, as described in the following examples.
Your Kafka brokers are reachable at (we will send you your credentials):
- University Vienna: `eddie-worker.projekte.fh-hagenberg.at:5001`
- Digital4Grids: `eddie-worker.projekte.fh-hagenberg.at:5002`
- Flexidao: `eddie-worker.projekte.fh-hagenberg.at:5003`
- Eta+: `eddie-worker.projekte.fh-hagenberg.at:5004`

### Postgres
The Postgres database is used by EDDIE Core to store data.
In general there should be no reason, why you need access to this database.
Please contact us, if you require access.

## Kafka Connection Examples
We are currently using a self-signed Certificate Authority for our Kafka Broker Certificates.
Consequently, you have to configure our root ca as trusted certificate, how this is done will be explained in the dedicated examples.
The CA certificate can be downloaded from the [SharePoint](https://hartnerconsultingcom.sharepoint.com/:u:/r/sites/EuropeanDataAccess/Freigegebene%20Dokumente/WPs/WP6_Demonstrators/Demo%20Deployment/root-ca-cert.pem?csf=1&web=1&e=UyyyRB).

### Kafkactl
Kafkactl is a very simple console tool, that can be used to interact with a Kafka Broker.
The simplest possible configuration looks like this:
```yaml
contexts:
  default:
    brokers:
      - eddie-worker.projekte.fh-hagenberg.at:5001 # TODO: replace port to your Kafka instance port
    sasl:
      enabled: true
      username: # REPLACE ME
      password: # REPLACE ME
      mechanism: scram-sha512
    tls:
      enabled: true
      ca: path-to-downloaded-ca # REPLACE ME
current-context: default
```

### 