package javax.ws.rs.client;

public abstract interface Client extends javax.ws.rs.core.Configurable {

    public abstract javax.ws.rs.client.WebTarget target(java.lang.String arg0);

    public abstract javax.ws.rs.client.WebTarget target(java.net.URI arg0);

    public abstract javax.ws.rs.client.WebTarget target(javax.ws.rs.core.UriBuilder arg0);

    public abstract javax.ws.rs.client.WebTarget target(javax.ws.rs.core.Link arg0);
}