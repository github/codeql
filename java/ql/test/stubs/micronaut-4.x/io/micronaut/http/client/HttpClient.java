package io.micronaut.http.client;

public interface HttpClient {
    BlockingHttpClient toBlocking();
}
