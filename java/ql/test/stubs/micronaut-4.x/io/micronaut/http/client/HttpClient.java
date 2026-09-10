package io.micronaut.http.client;

import io.micronaut.http.HttpRequest;
import io.micronaut.core.type.Argument;

public interface HttpClient {
    BlockingHttpClient toBlocking();
    Object exchange(HttpRequest<?> request);
    <O> Object exchange(HttpRequest<?> request, Class<O> bodyType);
    <O> Object exchange(HttpRequest<?> request, Argument<O> bodyType);
    <O, E> Object exchange(HttpRequest<?> request, Argument<O> bodyType, Argument<E> errorType);
    Object exchange(String uri);
    <O> Object exchange(String uri, Class<O> bodyType);
    Object retrieve(HttpRequest<?> request);
    <O> Object retrieve(HttpRequest<?> request, Class<O> bodyType);
    <O> Object retrieve(HttpRequest<?> request, Argument<O> bodyType);
    <O, E> Object retrieve(HttpRequest<?> request, Argument<O> bodyType, Argument<E> errorType);
    Object retrieve(String uri);
}
