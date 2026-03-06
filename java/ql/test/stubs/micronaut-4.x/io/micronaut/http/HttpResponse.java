package io.micronaut.http;

import java.net.URI;
import java.util.Optional;

public interface HttpResponse<B> {
    HttpStatus getStatus();
    int code();
    HttpHeaders getHeaders();
    Optional<B> getBody();

    static <T> MutableHttpResponse<T> ok() { return null; }
    static <T> MutableHttpResponse<T> ok(T body) { return null; }
    static MutableHttpResponse<?> redirect(URI location) { return null; }
    static MutableHttpResponse<?> notFound() { return null; }
    static MutableHttpResponse<?> badRequest() { return null; }
    static MutableHttpResponse<?> serverError() { return null; }
}
