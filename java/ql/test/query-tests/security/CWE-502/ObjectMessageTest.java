import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.ObjectMessage;

public class ObjectMessageTest implements MessageListener {
    public void onMessage(Message message) { // $ Source
        ((ObjectMessage) message).getObject(); // $ Alert
    }
}
