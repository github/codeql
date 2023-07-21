// Generated automatically from org.springframework.http.server.reactive.ServerHttpResponse for testing purposes

package org.springframework.http.server.reactive;

import org.springframework.http.HttpStatus;
import org.springframework.http.ReactiveHttpOutputMessage;
import org.springframework.http.ResponseCookie;
import org.springframework.util.MultiValueMap;

public interface ServerHttpResponse extends ReactiveHttpOutputMessage
{
    HttpStatus getStatusCode();
    MultiValueMap<String, ResponseCookie> getCookies();
    boolean setStatusCode(HttpStatus p0);
    default Integer getRawStatusCode(){ return null; }
    default boolean setRawStatusCode(Integer p0){ return false; }
    void addCookie(ResponseCookie p0);
}
