package javax.jms;

public interface StreamMessage extends Message {
    int readBytes(byte[] value);

    String readString();

    Object readObject();
}
