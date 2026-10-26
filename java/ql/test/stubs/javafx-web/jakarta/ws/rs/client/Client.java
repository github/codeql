// Generated automatically from jakarta.ws.rs.client.Client for testing purposes

package jakarta.ws.rs.client;

import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.Configurable;
import jakarta.ws.rs.core.Link;
import jakarta.ws.rs.core.UriBuilder;
import java.net.URI;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;

public interface Client extends AutoCloseable, Configurable<Client>
{
    HostnameVerifier getHostnameVerifier();
    Invocation.Builder invocation(Link p0);
    SSLContext getSslContext();
    WebTarget target(Link p0);
    WebTarget target(String p0);
    WebTarget target(URI p0);
    WebTarget target(UriBuilder p0);
    void close();
}
