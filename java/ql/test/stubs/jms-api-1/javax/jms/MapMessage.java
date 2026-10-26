package javax.jms;

public interface MapMessage extends Message {
    byte[] getBytes(String name);

    String getString(String name);
}
