// Generated automatically from jakarta.ws.rs.client.ClientBuilder for testing purposes

package jakarta.ws.rs.client;

import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.core.Configurable;
import jakarta.ws.rs.core.Configuration;
import java.security.KeyStore;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;

abstract public class ClientBuilder implements Configurable<ClientBuilder>
{
    protected ClientBuilder(){}
    public ClientBuilder keyStore(KeyStore p0, String p1){ return null; }
    public abstract Client build();
    public abstract ClientBuilder connectTimeout(long p0, TimeUnit p1);
    public abstract ClientBuilder executorService(ExecutorService p0);
    public abstract ClientBuilder hostnameVerifier(HostnameVerifier p0);
    public abstract ClientBuilder keyStore(KeyStore p0, char[] p1);
    public abstract ClientBuilder readTimeout(long p0, TimeUnit p1);
    public abstract ClientBuilder scheduledExecutorService(ScheduledExecutorService p0);
    public abstract ClientBuilder sslContext(SSLContext p0);
    public abstract ClientBuilder trustStore(KeyStore p0);
    public abstract ClientBuilder withConfig(Configuration p0);
    public static Client newClient(){ return null; }
    public static Client newClient(Configuration p0){ return null; }
    public static ClientBuilder newBuilder(){ return null; }
    public static String JAXRS_DEFAULT_CLIENT_BUILDER_PROPERTY = null;
}
