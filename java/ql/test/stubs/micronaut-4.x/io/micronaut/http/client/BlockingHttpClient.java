package io.micronaut.http.client;

import io.micronaut.http.HttpRequest;
import io.micronaut.http.HttpResponse;

public interface BlockingHttpClient {
    <I, O> HttpResponse<O> exchange(HttpRequest<I> request, Class<O> bodyType);
    <I, O> HttpResponse<O> exchange(HttpRequest<I> request);
    String retrieve(String uri);
    <O> O retrieve(String uri, Class<O> bodyType);
    String exchange(String uri);
    <O> HttpResponse<O> exchange(String uri, Class<O> bodyType);
}
