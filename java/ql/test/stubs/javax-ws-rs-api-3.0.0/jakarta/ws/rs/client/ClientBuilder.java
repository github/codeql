package jakarta.ws.rs.client;

public abstract class ClientBuilder implements jakarta.ws.rs.core.Configurable {

    protected ClientBuilder() {
    }

    public static jakarta.ws.rs.client.ClientBuilder newBuilder() {
        return null;
    }

    public static jakarta.ws.rs.client.Client newClient() {
        return null;
    }

    public static jakarta.ws.rs.client.Client newClient(jakarta.ws.rs.core.Configuration configuration) {
        return null;
    }
}