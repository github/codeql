// Generated automatically from org.springframework.http.client.reactive.ClientHttpResponse for testing purposes

package org.springframework.http.client.reactive;

import org.springframework.http.HttpStatus;
import org.springframework.http.ReactiveHttpInputMessage;
import org.springframework.http.ResponseCookie;
import org.springframework.util.MultiValueMap;

public interface ClientHttpResponse extends ReactiveHttpInputMessage
{
    HttpStatus getStatusCode();
    MultiValueMap<String, ResponseCookie> getCookies();
    default String getId(){ return null; }
    int getRawStatusCode();
}
