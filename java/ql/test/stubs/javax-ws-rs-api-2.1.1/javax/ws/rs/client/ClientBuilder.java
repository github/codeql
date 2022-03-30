package javax.ws.rs.client;

public abstract class ClientBuilder implements javax.ws.rs.core.Configurable {

    protected ClientBuilder() {
    }

    public static javax.ws.rs.client.ClientBuilder newBuilder() {
        return null;
    }

    public static javax.ws.rs.client.Client newClient() {
        return null;
    }

    public static javax.ws.rs.client.Client newClient(javax.ws.rs.core.Configuration configuration) {
        return null;
    }
}