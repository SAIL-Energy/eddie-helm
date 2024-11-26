using Confluent.Kafka;

namespace CsDemoExample;

internal static class Program
{
    public static void Main()
    {
        var consumerConfig = new ConsumerConfig
        {
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
        };


        using var kafkaConsumer = new ConsumerBuilder<Ignore, string>(consumerConfig).Build();
        kafkaConsumer.Subscribe("validated-historical-data");

        while (true)
        {
            var consumerRecord = kafkaConsumer.Consume();
            Console.WriteLine(consumerRecord.Message.Value);
        }
        kafkaConsumer.Close();
    }
}