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