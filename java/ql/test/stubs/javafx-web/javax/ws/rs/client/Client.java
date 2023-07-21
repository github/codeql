// Generated automatically from javax.ws.rs.client.Client for testing purposes

package javax.ws.rs.client;

import java.net.URI;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Configurable;
import javax.ws.rs.core.Link;
import javax.ws.rs.core.UriBuilder;

public interface Client extends Configurable<Client>
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
