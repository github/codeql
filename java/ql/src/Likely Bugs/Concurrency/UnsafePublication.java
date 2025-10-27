public class UnsafePublication {
    private Object value;
    private int server_id;

    public UnsafePublication() {
        value = new Object(); // Not safely published, other threads may see the default value null
        server_id = 1; // Not safely published, other threads may see the default value 0
    }

    public Object getValue() {
        return value;
    }

    public int getServerId() {
        return server_id;
    }
}