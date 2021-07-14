package org.springframework.http;

public class RequestEntity<T> extends org.springframework.http.HttpEntity {

    public RequestEntity(org.springframework.http.HttpMethod method, java.net.URI url) {
    }

    public RequestEntity(T body, org.springframework.http.HttpMethod method, java.net.URI url) {
    }

    public RequestEntity(T body, org.springframework.http.HttpMethod method, java.net.URI url,
            java.lang.reflect.Type type) {
    }

    public RequestEntity(org.springframework.util.MultiValueMap<java.lang.String, java.lang.String> headers,
            org.springframework.http.HttpMethod method, java.net.URI url) {
    }

    public RequestEntity(T body, org.springframework.util.MultiValueMap<java.lang.String, java.lang.String> headers,
            org.springframework.http.HttpMethod method, java.net.URI url) {
    }

    public RequestEntity(T body, org.springframework.util.MultiValueMap<java.lang.String, java.lang.String> headers,
            org.springframework.http.HttpMethod method, java.net.URI url, java.lang.reflect.Type type) {
    }

    public java.net.URI getUrl() {
        return null;
    }

    public static org.springframework.http.RequestEntity.BodyBuilder method(org.springframework.http.HttpMethod method,
            java.net.URI url) {
        return null;
    }

    public static org.springframework.http.RequestEntity.HeadersBuilder get(java.net.URI url) {
        return null;
    }

    public static org.springframework.http.RequestEntity.HeadersBuilder head(java.net.URI url) {
        return null;
    }

    public static org.springframework.http.RequestEntity.BodyBuilder post(java.net.URI url) {
        return null;
    }

    public static org.springframework.http.RequestEntity.BodyBuilder put(java.net.URI url) {
        return null;
    }

    public static org.springframework.http.RequestEntity.BodyBuilder patch(java.net.URI url) {
        return null;
    }

    public static org.springframework.http.RequestEntity.HeadersBuilder delete(java.net.URI url) {
        return null;
    }

    public static org.springframework.http.RequestEntity.HeadersBuilder options(java.net.URI url) {
        return null;
    }

    class HeadersBuilder<K> {
    }

    public class BodyBuilder<T> {
        public RequestEntity<T> body(Object body){return null;};
    }
}
