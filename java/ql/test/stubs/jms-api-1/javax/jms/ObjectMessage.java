package javax.jms;

public interface ObjectMessage extends Message {
    java.io.Serializable getObject();
}
