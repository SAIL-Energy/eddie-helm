# EDDIE Demo Instances User Documentation
Dear Partners,  
for the development of demonstrator applications we (FH) will provide a dedicated EDDIE instance for each partner.
***Please note, that the demo instances are still in an experimental phase, and we cannot assure, that your data will be persisted permanently.***
***For instance, we are planning on migrating to a new server very soon, which will cause data loss.***
If you are experiencing any issues, please create Bug Tickets in our [GitHub project](https://github.com/eddie-energy/eddie-helm/issues/new?assignees=&labels=bug&projects=&template=bug.md&title=).
When you received this documentation, your developer accounts should already have permission to create Bugs, otherwise please contact us.

## Fundamentals
Each EDDIE instance currently consists of the following components:
- EDDIE Core
- Kafka
- Postgres

Alternatively to Kafka, EDDIE supports AMQP (Advanced Message Queuing Protocol).
Currently, our deployment does not include an AMQP broker.
If you are hosting an AMQP supporting broker e.g. RabbitMQ yourself, please contact us, so we can configure your EDDIE instance to use this broker.

### EDDIE Core
As the name suggests, EDDIE Core contains the major logic of the EDDIE framework. 
It includes the logic to retrieve energy data using region-connectors and write it to outbound connectors e.g. Apache Kafka.
Your EDDIE Core instances are currently hosted on the following urls, those URLs are required to configure the EDDIE Connect Button:
- University Vienna: `https://eddie-demo.projekte.fh-hagenberg.at/univie/eddie`
- Digital4Grids: `https://eddie-demo.projekte.fh-hagenberg.at/d4g/eddie`
- Flexidao: `https://eddie-demo.projekte.fh-hagenberg.at/flexidao/eddie`
- Eta+: `https://eddie-demo.projekte.fh-hagenberg.at/etaplus/eddie`

For detailed documentation about EDDIE please refer to our official [Framework Documentation](https://eddie-web.projekte.fh-hagenberg.at/framework/).
 
#### Eddie Connect Button
You can embed the EDDIE Connect Button into your application with the following code:
```html
<head>
    ...
    # TODO: Replace with your EDDIE Core URL
    <script type="module" src="https://eddie-demo.projekte.fh-hagenberg.at/univie/eddie/lib/eddie-components.js"></script>
</head>
<body>
<eddie-connect-button
        data-need-id="9bd0668f-cc19-40a8-99db-dc2cb2802b17"
        connection-id="1"
></eddie-connect-button>

<script type="module">
    let button = document.querySelector("eddie-connect-button");
    button.setAttribute("connection-id", generateUUID());
    button.replaceWith(button);

    function generateUUID() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            const r = (Math.random() * 16) | 0;
            const v = c === 'x' ? r : (r & 0x3) | 0x8;
            return v.toString(16);
        });
    }
</script>
</body>
```
<!---
The full code examples can be viewed here:
- [Connect Button with Data Needs Dropdown](./demo-examples/ConnectButton/button-demo-dataneeds-dropdown.html)
- [Connect Button with fixed Data Need](./demo-examples/ConnectButton/button-demo-dataneeds-dropdown.html)
- [Connect Button with Data Needs Dropdown](https://github.com/eddie-energy/eddie-helm/blob/main/demo-examples/ConnectButton/button-demo-dataneeds-dropdown.html)
- [Connect Button with fixed Data Need](https://github.com/eddie-energy/eddie-helm/blob/main/demo-examples/ConnectButton/button-demo-fixed-dataneed.html)
--->

#### Admin Console
In the future you can observe the states of your permission requests and manage data needs in the Admin console.
For now, we had to disable the Admin Console for your deployments, because the Admin Console is currently not properly secured.
We are already working on securing the Admin Console and will keep you updated.

#### Supported Features
Depending on the configuration of your EDDIE instance, the region connectors can support different features.
To check, which features are supported by which region connector, you can use the following endpoints:
- University Vienna: `https://eddie-demo.projekte.fh-hagenberg.at/univie/eddie/management/region-connectors/supported-features`
- Digital4Grids: `https://eddie-demo.projekte.fh-hagenberg.at/d4g/eddie/management/region-connectors/supported-features`
- Flexidao: `https://eddie-demo.projekte.fh-hagenberg.at/flexidao/eddie/management/region-connectors/supported-features`
- Eta+: `https://eddie-demo.projekte.fh-hagenberg.at/etaplus/eddie/management/region-connectors/supported-features`

#### Data Needs
Your EDDIE Core instance is preconfigured with a set of data needs, your current Data Needs can be viewed at:
- University Vienna: `https://eddie-demo.projekte.fh-hagenberg.at/univie/eddie/data-needs/api`
- Digital4Grids: `https://eddie-demo.projekte.fh-hagenberg.at/d4g/eddie/data-needs/api`
- Flexidao: `https://eddie-demo.projekte.fh-hagenberg.at/flexidao/eddie/data-needs/api`
- Eta+: `https://eddie-demo.projekte.fh-hagenberg.at/etaplus/eddie/data-needs/api`
 
If you want to create additional Data Needs, please use our API at `your-eddie-url/data-needs/management`.
You can find an extensive documentation for configuring data needs in our [documentation](https://eddie-web.projekte.fh-hagenberg.at/framework/1-running/OPERATION.html#data-need-configuration) (swagger is currently disabled on the deployed instances, please use other http tools to creat data needs).

It is also important to know, that not each data need works for each region connector.
To get information about the data need restrictions of the region connectors (e.g. supported granularities) use this endpoint:
- University Vienna: `https://eddie-demo.projekte.fh-hagenberg.at/univie/eddie/api/region-connectors-metadata`
- Digital4Grids: `https://eddie-demo.projekte.fh-hagenberg.at/d4g/eddie/api/region-connectors-metadata`
- Flexidao: `https://eddie-demo.projekte.fh-hagenberg.at/flexidao/eddie/api/region-connectors-metadata`
- Eta+: `https://eddie-demo.projekte.fh-hagenberg.at/etaplus/eddie/api/region-connectors-metadata`

You could use the following curl command to create a data-need:
```bash
curl -X POST eddieUrl/data-needs/management \
	-H "Content-Type: application/json" \
	-d '{
        "type": "validated",
        "policyLink": "",
        "name": "Last 3 Months",
        "description": "",
        "purpose": "",
        "duration": {
          "type": "relativeDuration",
          "start": "-P3M",
          "end": "P-1D"
        },
        "energyType": "ELECTRICITY",
        "minGranularity": "PT15M",
        "maxGranularity": "PT1H"
        }'
```

### Kafka
Currently, the deployment contains one single Kafka Broker for each instance.
The Kafka Broker is running in KRaft mode and external communication is secured with SASL_SSL.
Therefore, communication is encrypted, and you need an account for authentication to access data.
Furthermore, we are using a self-signed certificate for SSL, which means you need to trust our self-signed certificate manually, as described in the following examples.
Your Kafka brokers are reachable at (we will send you your credentials):
- University Vienna: `eddie-demo.projekte.fh-hagenberg.at:5001`
- Digital4Grids: `eddie-demo.projekte.fh-hagenberg.at:5002`
- Flexidao: `eddie-demo.projekte.fh-hagenberg.at:5003`
- Eta+: `eddie-demo.projekte.fh-hagenberg.at:5004`

Detailed information about the currently used Kafka topics can be found [in the Kafka section of our Framework Documentation](https://eddie-web.projekte.fh-hagenberg.at/framework/2-integrating/KAFKA.html).

### Postgres
The Postgres database is used by EDDIE Core to store data.
In general there should be no reason, why you need access to this database.
Please contact us, if you require access.

## Kafka Connection Examples
We are currently using a self-signed Certificate Authority for our Kafka Broker Certificates.
Consequently, you have to configure our root ca as trusted certificate, how this is done will be explained in the dedicated examples.
The CA certificate can be downloaded from the [SharePoint](https://hartnerconsultingcom.sharepoint.com/:u:/r/sites/EuropeanDataAccess/Freigegebene%20Dokumente/WPs/WP6_Demonstrators/Demo%20Deployment/root-ca-cert.pem?csf=1&web=1&e=UyyyRB).  
The following examples show you the basic configuration and should give you a good starting point for your applications.
If your programming language is not included in the following examples, please create an Issue, so we can improve our documentation.

### Kafkactl
Kafkactl is a very simple console tool, that can be used to interact with a Kafka Broker.
The simplest possible configuration looks like this:
```yaml
contexts:
  default:
    brokers:
      - eddie-demo.projekte.fh-hagenberg.at:5001 # TODO: replace port to your Kafka instance port
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

### Java
First of all you have to configure your Java installation to trust our CA, this can be done as follows:  
Linux:
```bash
cd $JAVA_HOME # Assuming your JAVA_HOME is configured, otherwise use the path to your java installation
keytool -keystore ../lib/security/cacerts -import -alias eddie-demo.projekte.fh-hagenberg.at -file path-to-downloaded-ca # Replace path to root ca
```
Powershell (not verified):
```bash
cd $env:JAVA_HOME # Assuming your JAVA_HOME is configured, otherwise use the path to your java installation
keytool.exe -keystore "../lib/security/cacerts" -import -alias eddie-demo.projekte.fh-hagenberg.at -file "path-to-downloaded-ca"
```

Then you can configure your configurations in your `kafka-consumer.properties` file:
```yaml
# General
bootstrap.servers=eddie-demo.projekte.fh-hagenberg.at:5001 # TODO: replace port to your Kafka instance port
group.id=univie-kafka-client-group # TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)
client.id=univie-kafka-client # TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)

# Security
security.protocol=SASL_SSL
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username='' password=''; # TODO: Insert your Credentials
sasl.mechanism=SCRAM-SHA-512

# Application Specific, you have to adapt these values for your application
key.deserializer=org.apache.kafka.common.serialization.StringDeserializer
value.deserializer=org.apache.kafka.common.serialization.StringDeserializer
auto.offset.reset=earliest
```

Then you can install the Kafka client by adding this to your dependencies:
```groovy
dependencies {
    // https://mvnrepository.com/artifact/org.apache.kafka/kafka-clients
    implementation 'org.apache.kafka:kafka-clients:3.9.0'
    ...
}
```

This code should give you an idea, how to create the Kafka Consumer, for real usage examples please refer to the documentation of your used framework e.g. spring boot:
```java
package energy.eddie.demodeployment;

import org.apache.kafka.clients.consumer.KafkaConsumer;
import java.io.IOException;
import java.time.Duration;
import java.util.List;
import java.util.Properties;

public class Main {
    public static final ClassLoader classloader = Thread.currentThread().getContextClassLoader();

    public static void main(String[] args) throws IOException {
        Properties consumerProperties = new Properties();
        consumerProperties.load(classloader.getResourceAsStream("kafka-consumer.properties"));

        try (var consumer = new KafkaConsumer<String, String>(consumerProperties)) {
            consumer.subscribe(List.of("validated-historical-data"));

            while (true) {
                var records = consumer.poll(Duration.ofMillis(Long.MAX_VALUE));
                records.forEach(record -> System.out.println(record.value()));
            }
        }
    }
}
```

### C#
First of all you have to add this package to your NuGets:
```xml
<ItemGroup>
<PackageReference Include="Confluent.Kafka" Version="2.6.1" />
</ItemGroup>
```

This code should give you an idea, how to create the Kafka Consumer, for real usage examples please refer to the documentation of your used framework:
```cs
using Confluent.Kafka;

namespace CsDemoExample;

internal static class Program
{
    public static void Main()
    {
        var consumerConfig = new ConsumerConfig
        {
            // General
            BootstrapServers = "eddie-demo.projekte.fh-hagenberg.at:5001", // TODO: replace port to your Kafka instance port
            GroupId = "univie-kafka-client-group", // TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)
            ClientId = "univie-kafka-client", // TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)

            // Security
            SecurityProtocol = SecurityProtocol.SaslSsl,
            SslCaLocation = "path-to-downloaded-ca", // TODO: replace with path to ca
            SaslMechanism = SaslMechanism.ScramSha512,
            SaslUsername = "univie-kafka-client", // TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)
            SaslPassword = "", // TODO: replace with your credentials

            // Application Specific, you have to adapt these values for your application
            AutoOffsetReset = AutoOffsetReset.Earliest
        };


        using var kafkaConsumer = new ConsumerBuilder<Ignore, string>(consumerConfig).Build();
        kafkaConsumer.Subscribe("validated-historical-data");

        while (true)
        {
            var consumerRecord = kafkaConsumer.Consume();
            Console.WriteLine(consumerRecord.Message.Value);
        }
    }
}
```

### Python
First of all you have to install the `python-kafka` library, but according to an [GitHub Issue](https://github.com/dpkp/kafka-python/issues/2412), there is a problem with `python-kafka` if the used python version is greater than `3.11`.
The following `requirements.txt` file works for python version `3.12`:
```text
kafka-python==2.0.2; python_version < '3.12'
kafka-python @ git+https://github.com/dpkp/kafka-python.git ; python_version >= '3.12'
```

This code should give you an idea, how to create the Kafka Consumer, for real usage examples please refer to the documentation of your used framework:
```python
from kafka import KafkaConsumer

consumer = KafkaConsumer(
    'validated-historical-data',
    # General
    bootstrap_servers='eddie-demo.projekte.fh-hagenberg.at:5001', # TODO: replace port to your Kafka instance port
    group_id='univie-kafka-client-group', # TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)
    client_id='univie-kafka-client', # TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)

    # Security
    security_protocol='SASL_SSL',
    ssl_cafile="", # TODO: replace with path to downloaded ca
    sasl_mechanism="SCRAM-SHA-512",
    sasl_plain_username="univie-kafka-client", # TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)
    sasl_plain_password="", # TODO: Insert your credentials

    # Application Specific
    auto_offset_reset='earliest',
)

print("Listening to validated-historical-data...")

for message in consumer:
    print({message.value})
```

### F#
First of all you have to add this package to your NuGets:
```xml
<ItemGroup>
<PackageReference Include="Confluent.Kafka" Version="2.6.1" />
</ItemGroup>
```

This code should give you an idea, how to create the Kafka Consumer, for real usage examples please refer to the documentation of your used framework:
```fsharp
open Confluent.Kafka

let consumerConfig =
    ConsumerConfig(
        // General
        BootstrapServers = "eddie-demo.projekte.fh-hagenberg.at:5001", // TODO: replace port to your Kafka instance port
        GroupId = "univie-kafka-client-group", // TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)
        ClientId = "univie-kafka-client", // TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)

        // Security
        SecurityProtocol = SecurityProtocol.SaslSsl,
        SslCaLocation = "path-to-downloaded-ca", // TODO: replace with path to ca
        SaslMechanism = SaslMechanism.ScramSha512,
        SaslUsername = "univie-kafka-client", // TODO: replace prefix with your prefix (univie,d4g,flexidao,etaplus)
        SaslPassword = "", // TODO: replace with your credentials

        // Application Specific, you have to adapt these values for your application
        AutoOffsetReset = AutoOffsetReset.Earliest
    )

let kafkaConsumer = ConsumerBuilder<Ignore, string>(consumerConfig).Build();
kafkaConsumer.Subscribe("validated-historical-data");

while (true) do
    let consumerRecord = kafkaConsumer.Consume()
    printfn $"%s{consumerRecord.Message.Value}"
    
kafkaConsumer.Close();
```
