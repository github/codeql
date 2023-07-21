// Generated automatically from org.springframework.http.client.ClientHttpRequestInterceptor for testing purposes

package org.springframework.http.client;

import org.springframework.http.HttpRequest;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpResponse;

public interface ClientHttpRequestInterceptor
{
    ClientHttpResponse intercept(HttpRequest p0, byte[] p1, ClientHttpRequestExecution p2);
}
