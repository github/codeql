import javax.jms.MessageListener;
import javax.jms.TextMessage;
import javax.jms.BytesMessage;
import javax.jms.MapMessage;
import javax.jms.ObjectMessage;
import javax.jms.StreamMessage;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.QueueReceiver;
import javax.jms.QueueRequestor;
import javax.jms.TopicRequestor;

public class MessageListenerImpl implements MessageListener {

    @Override
    public void onMessage(Message message) { // $source
        try {
            if (message instanceof TextMessage) {
                TextMessage textMessage = (TextMessage) message;
                String text = textMessage.getText();
                sink(text); // $detected
            } else if (message instanceof BytesMessage) {
                BytesMessage bytesMessage = (BytesMessage) message;
                byte[] data = new byte[1024];
                bytesMessage.readBytes(data, 42);
                sink(new String(data)); // $detected
                sink(bytesMessage.readUTF()); // $detected
            } else if (message instanceof MapMessage) {
                MapMessage mapMessage = (MapMessage) message;
                sink(mapMessage.getString("data")); // $detected
                sink(new String(mapMessage.getBytes("bytes"))); // $detected
            } else if (message instanceof ObjectMessage) {
                ObjectMessage objectMessage = (ObjectMessage) message;
                sink((String) objectMessage.getObject()); // $detected
            } else if (message instanceof StreamMessage) {
                StreamMessage streamMessage = (StreamMessage) message;
                byte[] data = new byte[1024];
                streamMessage.readBytes(data);
                sink(new String(data)); // $detected
                sink(streamMessage.readString()); // $detected
                sink((String) streamMessage.readObject()); // $detected
            }
        } catch (Exception e) {
        }
    }

    public void readFromCounsumer(MessageConsumer consumer) throws Exception {
        TextMessage message = (TextMessage) consumer.receive(5000); // $source
        String text = message.getText();
        sink(text); // $detected
        message = (TextMessage) consumer.receive(); // $source
        text = message.getText();
        sink(text); // $detected
        message = (TextMessage) consumer.receiveNoWait(); // $source
        text = message.getText();
        sink(text); // $detected
    }

    public void readFromQueueRequestor(QueueRequestor requestor, Message message) throws Exception {
        TextMessage reply = (TextMessage) requestor.request(message); // $source
        String text = reply.getText();
        sink(text); // $detected
    }

    public void readFromTopicRequestor(TopicRequestor requestor, Message message) throws Exception {
        TextMessage reply = (TextMessage) requestor.request(message); // $source
        String text = reply.getText();
        sink(text); // $detected
    }

    private void sink(String data) {
    }
}
