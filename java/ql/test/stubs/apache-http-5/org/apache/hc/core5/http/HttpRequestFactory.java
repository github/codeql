// Generated automatically from org.apache.hc.core5.http.HttpRequestFactory for testing purposes

package org.apache.hc.core5.http;

import java.net.URI;
import org.apache.hc.core5.http.HttpRequest;

public interface HttpRequestFactory<T extends HttpRequest>
{
    T newHttpRequest(String p0, String p1);
    T newHttpRequest(String p0, URI p1);
}
