import com.rabbitmq.client.DefaultConsumer;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.AMQP;
import com.rabbitmq.client.Envelope;
import com.rabbitmq.client.QueueingConsumer;

public class Test {

    public void defaultConsumerTest(Channel channel) {
        DefaultConsumer consumer = new DefaultConsumer(channel) {

            @Override
            public void handleDelivery(
                    String consumerTag, Envelope envelope, AMQP.BasicProperties properties, 
                    byte[] body) { // $source

                sink(body); // $hasTaintFlow
            }
        };
    }

    public void queueingConsumerTest(QueueingConsumer consumer) {
        while (true) {
            QueueingConsumer.Delivery delivery = consumer.nextDelivery(); // $source
            sink(delivery.getBody()); // $hasTaintFlow
            delivery = consumer.nextDelivery(42); // $source
            sink(delivery.getBody()); // $hasTaintFlow
        }
    }

    private void sink(byte[] data) {

    }
}
