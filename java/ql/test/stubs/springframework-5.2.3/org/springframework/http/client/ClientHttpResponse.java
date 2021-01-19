package org.springframework.http.client;

public abstract interface ClientHttpResponse {

    public abstract org.springframework.http.HttpStatus getStatusCode() throws java.io.IOException;

    public abstract int getRawStatusCode() throws java.io.IOException;

    public abstract java.lang.String getStatusText() throws java.io.IOException;

    public abstract void close();
}