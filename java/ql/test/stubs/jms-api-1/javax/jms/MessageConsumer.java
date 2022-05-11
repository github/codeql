package javax.jms;

public interface MessageConsumer {
    Message receive();

    Message receive(long timeout);

    Message receiveNoWait();
}
