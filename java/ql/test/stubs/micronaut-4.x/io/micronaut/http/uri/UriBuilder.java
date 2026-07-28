package io.micronaut.http.uri;

import java.net.URI;
import java.util.Map;

public interface UriBuilder {
    static UriBuilder of(CharSequence uri) { return null; }
    static UriBuilder of(URI uri) { return null; }
    UriBuilder host(String host);
    UriBuilder path(String path);
    UriBuilder queryParam(String name, Object... values);
    UriBuilder replacePath(String path);
    UriBuilder replaceQueryParam(String name, Object... values);
    UriBuilder scheme(String scheme);
    UriBuilder userInfo(String userInfo);
    UriBuilder fragment(String fragment);
    URI build();
    URI expand(Map<String, ? super Object> values);
}
