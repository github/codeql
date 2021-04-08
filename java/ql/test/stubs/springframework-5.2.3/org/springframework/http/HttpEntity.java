package org.springframework.http;

public class HttpEntity<T> {

    protected HttpEntity() {
    }

    public HttpEntity(T body) {
    }

    public HttpEntity(org.springframework.util.MultiValueMap<java.lang.String, java.lang.String> headers) {
    }

    public HttpEntity(T body, org.springframework.util.MultiValueMap<java.lang.String, java.lang.String> headers) {
    }

    public org.springframework.http.HttpHeaders getHeaders() {
        return null;
    }

    public T getBody() {
        return null;
    }

    public boolean hasBody() {
        return false;
    }

    public boolean equals(java.lang.Object other) {
        return false;
    }

    public int hashCode() {
        return 0;
    }

    public java.lang.String toString() {
        return null;
    }
}