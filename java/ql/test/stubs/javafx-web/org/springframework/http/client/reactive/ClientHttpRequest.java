// Generated automatically from org.springframework.http.client.reactive.ClientHttpRequest for testing purposes

package org.springframework.http.client.reactive;

import java.net.URI;
import org.springframework.http.HttpCookie;
import org.springframework.http.HttpMethod;
import org.springframework.http.ReactiveHttpOutputMessage;
import org.springframework.util.MultiValueMap;

public interface ClientHttpRequest extends ReactiveHttpOutputMessage
{
    <T> T getNativeRequest();
    HttpMethod getMethod();
    MultiValueMap<String, HttpCookie> getCookies();
    URI getURI();
}
