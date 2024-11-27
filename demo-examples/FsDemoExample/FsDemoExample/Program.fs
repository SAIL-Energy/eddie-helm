// For more information see https://aka.ms/fsharp-console-apps
open Confluent.Kafka

let consumerConfig =
    ConsumerConfig(
        // General
        BootstrapServers = "eddie-worker.projekte.fh-hagenberg.at:5001",
        GroupId = "univie-kafka-client-group",
        ClientId = "univie-kafka-client",

        // Security
        SecurityProtocol = SecurityProtocol.SaslSsl,
        SslCaLocation = "",
        SaslMechanism = SaslMechanism.ScramSha512,
        SaslUsername = "univie-kafka-client",
        SaslPassword = "",

        // Application Specific
        AutoOffsetReset = AutoOffsetReset.Earliest
    )

let kafkaConsumer = ConsumerBuilder<Ignore, string>(consumerConfig).Build();
kafkaConsumer.Subscribe("validated-historical-data");

while (true) do
    let consumerRecord = kafkaConsumer.Consume()
    printfn $"%s{consumerRecord.Message.Value}"
    
kafkaConsumer.Close();
