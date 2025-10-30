public class SafePublication {
    private volatile Object value;
    private final int server_id;

    public SafePublication() {
        value = new Object(); // Safely published as volatile
        server_id = 1; // Safely published as final
    }

    public synchronized Object getValue() {
        return value;
    }

    public int getServerId() {
        return server_id;
    }
}