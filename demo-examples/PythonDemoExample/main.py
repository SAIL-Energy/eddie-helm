from kafka import KafkaConsumer

consumer = KafkaConsumer(
    'validated-historical-data',
    # General
    bootstrap_servers='eddie-worker.projekte.fh-hagenberg.at:5001',
    group_id='univie-kafka-client-group',
    client_id='univie-kafka-client',

    # Security
    security_protocol='SASL_SSL',
    ssl_cafile="",
    sasl_mechanism="SCRAM-SHA-512",
    sasl_plain_username="univie-kafka-client",
    sasl_plain_password="",

    # Application Specific
    auto_offset_reset='earliest',
)

print("Listening to validated-historical-data...")

for message in consumer:
    print({message.value})
