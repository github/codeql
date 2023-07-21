// Generated automatically from org.apache.http.client.methods.HttpUriRequest for testing purposes

package org.apache.http.client.methods;

import java.net.URI;
import org.apache.http.HttpRequest;

public interface HttpUriRequest extends HttpRequest
{
    String getMethod();
    URI getURI();
    boolean isAborted();
    void abort();
}
