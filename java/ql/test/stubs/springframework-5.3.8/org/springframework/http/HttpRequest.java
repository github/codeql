// Generated automatically from org.springframework.http.HttpRequest for testing purposes

package org.springframework.http;

import java.net.URI;
import org.springframework.http.HttpMessage;
import org.springframework.http.HttpMethod;

public interface HttpRequest extends HttpMessage
{
    String getMethodValue();
    URI getURI();
    default HttpMethod getMethod(){ return null; }
}
