package io.micronaut.http;

import java.net.URI;
import java.util.Optional;
import io.micronaut.http.cookie.Cookies;

public interface HttpRequest<B> {
    Cookies getCookies();
    HttpHeaders getHeaders();
    HttpParameters getParameters();
    Optional<B> getBody();
    URI getUri();
    String getPath();
    Optional<MediaType> getContentType();
    long getContentLength();
    HttpMethod getMethod();
    String getMethodName();

    static <T> HttpRequest<T> GET(String uri) { return null; }
    static <T> HttpRequest<T> POST(String uri, T body) { return null; }
    static <T> HttpRequest<T> PUT(String uri, T body) { return null; }
    static HttpRequest<?> DELETE(String uri) { return null; }
    static <T> HttpRequest<T> PATCH(String uri, T body) { return null; }
    static HttpRequest<?> HEAD(String uri) { return null; }
    static HttpRequest<?> OPTIONS(String uri) { return null; }
}
