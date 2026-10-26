// Generated automatically from org.springframework.http.client.ClientHttpRequest for testing purposes

package org.springframework.http.client;

import org.springframework.http.HttpOutputMessage;
import org.springframework.http.HttpRequest;
import org.springframework.http.client.ClientHttpResponse;

public interface ClientHttpRequest extends HttpOutputMessage, HttpRequest
{
    ClientHttpResponse execute();
}
