package io.micronaut.http.client;

import io.micronaut.http.HttpRequest;
import io.micronaut.http.HttpResponse;
import io.micronaut.core.type.Argument;

public interface BlockingHttpClient {
    <I, O> HttpResponse<O> exchange(HttpRequest<I> request, Class<O> bodyType);
    <I, O> HttpResponse<O> exchange(HttpRequest<I> request, Argument<O> bodyType);
    <I, O, E> HttpResponse<O> exchange(HttpRequest<I> request, Argument<O> bodyType, Argument<E> errorType);
    <I, O> HttpResponse<O> exchange(HttpRequest<I> request);
    <I> String retrieve(HttpRequest<I> request);
    <I, O> O retrieve(HttpRequest<I> request, Class<O> bodyType);
    <I, O> O retrieve(HttpRequest<I> request, Argument<O> bodyType);
    <I, O, E> O retrieve(HttpRequest<I> request, Argument<O> bodyType, Argument<E> errorType);
    String retrieve(String uri);
    <O> O retrieve(String uri, Class<O> bodyType);
    <O, E> O retrieve(String uri, Class<O> bodyType, Class<E> errorType);
    String exchange(String uri);
    <O> HttpResponse<O> exchange(String uri, Class<O> bodyType);
    <O, E> HttpResponse<O> exchange(String uri, Class<O> bodyType, Class<E> errorType);
}
