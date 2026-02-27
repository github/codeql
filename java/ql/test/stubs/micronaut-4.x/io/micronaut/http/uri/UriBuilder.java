package io.micronaut.http.uri;

import java.net.URI;

public interface UriBuilder {
    static UriBuilder of(CharSequence uri) { return null; }
    static UriBuilder of(URI uri) { return null; }
    UriBuilder host(String host);
    UriBuilder path(String path);
    UriBuilder queryParam(String name, Object... values);
    UriBuilder fragment(String fragment);
    URI build();
}
