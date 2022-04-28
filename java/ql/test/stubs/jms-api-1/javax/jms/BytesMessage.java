package javax.jms;

public interface BytesMessage extends Message {
    int readBytes(byte[] value);

    int readBytes(byte[] value, int length);

    String readUTF();
}