package io.micronaut.http.cookie;

public interface Cookie {
    String getName();
    String getValue();
    String getDomain();
    String getPath();
    boolean isHttpOnly();
    boolean isSecure();
    long getMaxAge();
}
