// Generated automatically from org.springframework.web.client.ResponseErrorHandler for testing purposes

package org.springframework.web.client;

import java.net.URI;
import org.springframework.http.HttpMethod;
import org.springframework.http.client.ClientHttpResponse;

public interface ResponseErrorHandler
{
    boolean hasError(ClientHttpResponse p0);
    default void handleError(URI p0, HttpMethod p1, ClientHttpResponse p2){}
    void handleError(ClientHttpResponse p0);
}
