// Generated automatically from jakarta.ws.rs.client.WebTarget for testing purposes

package jakarta.ws.rs.client;

import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.core.Configurable;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.UriBuilder;
import java.net.URI;
import java.util.Map;

public interface WebTarget extends Configurable<WebTarget>
{
    Invocation.Builder request();
    Invocation.Builder request(MediaType... p0);
    Invocation.Builder request(String... p0);
    URI getUri();
    UriBuilder getUriBuilder();
    WebTarget matrixParam(String p0, Object... p1);
    WebTarget path(String p0);
    WebTarget queryParam(String p0, Object... p1);
    WebTarget resolveTemplate(String p0, Object p1);
    WebTarget resolveTemplate(String p0, Object p1, boolean p2);
    WebTarget resolveTemplateFromEncoded(String p0, Object p1);
    WebTarget resolveTemplates(Map<String, Object> p0);
    WebTarget resolveTemplates(Map<String, Object> p0, boolean p1);
    WebTarget resolveTemplatesFromEncoded(Map<String, Object> p0);
}
