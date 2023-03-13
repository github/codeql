// Generated automatically from javax.ws.rs.client.ClientBuilder for testing purposes

package javax.ws.rs.client;

import java.security.KeyStore;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.ws.rs.client.Client;
import javax.ws.rs.core.Configurable;
import javax.ws.rs.core.Configuration;

abstract public class ClientBuilder implements Configurable<ClientBuilder>
{
    protected ClientBuilder(){}
    public ClientBuilder keyStore(KeyStore p0, String p1){ return null; }
    public abstract Client build();
    public abstract ClientBuilder hostnameVerifier(HostnameVerifier p0);
    public abstract ClientBuilder keyStore(KeyStore p0, char[] p1);
    public abstract ClientBuilder sslContext(SSLContext p0);
    public abstract ClientBuilder trustStore(KeyStore p0);
    public abstract ClientBuilder withConfig(Configuration p0);
    public static Client newClient(){ return null; }
    public static Client newClient(Configuration p0){ return null; }
    public static ClientBuilder newBuilder(){ return null; }
    public static String JAXRS_DEFAULT_CLIENT_BUILDER_PROPERTY = null;
}
