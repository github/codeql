// Generated automatically from javax.ws.rs.client.WebTarget for testing purposes

package javax.ws.rs.client;

import java.net.URI;
import java.util.Map;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.Configurable;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;

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
