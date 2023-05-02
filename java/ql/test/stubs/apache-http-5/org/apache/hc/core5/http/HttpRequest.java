// Generated automatically from org.apache.hc.core5.http.HttpRequest for testing purposes

package org.apache.hc.core5.http;

import java.net.URI;
import org.apache.hc.core5.http.HttpMessage;
import org.apache.hc.core5.net.URIAuthority;

public interface HttpRequest extends HttpMessage
{
    String getMethod();
    String getPath();
    String getRequestUri();
    String getScheme();
    URI getUri();
    URIAuthority getAuthority();
    void setAuthority(URIAuthority p0);
    void setPath(String p0);
    void setScheme(String p0);
    void setUri(URI p0);
}
