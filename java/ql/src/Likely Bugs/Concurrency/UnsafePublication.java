@ThreadSafe
public class UnsafePublication {
    private Object value;

    public void produce() {
        value = new Object(); // Not safely published, other threads may see the default value null
    }

    public Object getValue() {
        return value;
    }
}