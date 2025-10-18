public class SafePublication {
    private Object value;

    public synchronized void produce() {
        value = new Object(); // Safely published using synchronization
    }

    public synchronized Object getValue() {
        return value;
    }
}