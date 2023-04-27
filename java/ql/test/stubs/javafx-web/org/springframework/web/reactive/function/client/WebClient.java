// Generated automatically from org.springframework.web.reactive.function.client.WebClient for testing purposes

package org.springframework.web.reactive.function.client;

import io.micrometer.observation.ObservationRegistry;
import java.net.URI;
import java.nio.charset.Charset;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.IntPredicate;
import java.util.function.Predicate;
import org.reactivestreams.Publisher;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.ReactiveHttpInputMessage;
import org.springframework.http.ReactiveHttpOutputMessage;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.reactive.ClientHttpConnector;
import org.springframework.http.client.reactive.ClientHttpRequest;
import org.springframework.http.client.reactive.ClientHttpResponse;
import org.springframework.http.codec.ClientCodecConfigurer;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyExtractor;
import org.springframework.web.reactive.function.BodyInserter;
import org.springframework.web.reactive.function.client.ClientRequestObservationConvention;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.ExchangeFilterFunction;
import org.springframework.web.reactive.function.client.ExchangeFunction;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.util.UriBuilder;
import org.springframework.web.util.UriBuilderFactory;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.util.context.Context;

public interface WebClient
{
    WebClient.Builder mutate();
    WebClient.RequestBodyUriSpec method(HttpMethod p0);
    WebClient.RequestBodyUriSpec patch();
    WebClient.RequestBodyUriSpec post();
    WebClient.RequestBodyUriSpec put();
    WebClient.RequestHeadersUriSpec<? extends Object> delete();
    WebClient.RequestHeadersUriSpec<? extends Object> get();
    WebClient.RequestHeadersUriSpec<? extends Object> head();
    WebClient.RequestHeadersUriSpec<? extends Object> options();
    static WebClient create(){ return null; }
    static WebClient create(String p0){ return null; }
    static WebClient.Builder builder(){ return null; }
    static public interface Builder
    {
        WebClient build();
        WebClient.Builder apply(java.util.function.Consumer<WebClient.Builder> p0);
        WebClient.Builder baseUrl(String p0);
        WebClient.Builder clientConnector(ClientHttpConnector p0);
        WebClient.Builder clone();
        WebClient.Builder codecs(Consumer<ClientCodecConfigurer> p0);
        WebClient.Builder defaultCookie(String p0, String... p1);
        WebClient.Builder defaultCookies(Consumer<MultiValueMap<String, String>> p0);
        WebClient.Builder defaultHeader(String p0, String... p1);
        WebClient.Builder defaultHeaders(Consumer<HttpHeaders> p0);
        WebClient.Builder defaultRequest(Consumer<WebClient.RequestHeadersSpec<? extends Object>> p0);
        WebClient.Builder defaultStatusHandler(Predicate<HttpStatusCode> p0, Function<ClientResponse, Mono<? extends Throwable>> p1);
        WebClient.Builder defaultUriVariables(Map<String, ? extends Object> p0);
        WebClient.Builder exchangeFunction(ExchangeFunction p0);
        WebClient.Builder exchangeStrategies(ExchangeStrategies p0);
        WebClient.Builder exchangeStrategies(java.util.function.Consumer<ExchangeStrategies.Builder> p0);
        WebClient.Builder filter(ExchangeFilterFunction p0);
        WebClient.Builder filters(Consumer<List<ExchangeFilterFunction>> p0);
        WebClient.Builder observationConvention(ClientRequestObservationConvention p0);
        WebClient.Builder observationRegistry(ObservationRegistry p0);
        WebClient.Builder uriBuilderFactory(UriBuilderFactory p0);
    }
    static public interface RequestBodySpec extends WebClient.RequestHeadersSpec<WebClient.RequestBodySpec>
    {
        <T, P extends org.reactivestreams.Publisher<T>> WebClient.RequestHeadersSpec<? extends Object> body(P p0, java.lang.Class<T> p1);
        <T, P extends org.reactivestreams.Publisher<T>> WebClient.RequestHeadersSpec<? extends Object> body(P p0, org.springframework.core.ParameterizedTypeReference<T> p1);
        WebClient.RequestBodySpec contentLength(long p0);
        WebClient.RequestBodySpec contentType(MediaType p0);
        WebClient.RequestHeadersSpec<? extends Object> body(BodyInserter<? extends Object, ? super ClientHttpRequest> p0);
        WebClient.RequestHeadersSpec<? extends Object> body(Object p0, Class<? extends Object> p1);
        WebClient.RequestHeadersSpec<? extends Object> body(Object p0, ParameterizedTypeReference<? extends Object> p1);
        WebClient.RequestHeadersSpec<? extends Object> bodyValue(Object p0);
        WebClient.RequestHeadersSpec<? extends Object> syncBody(Object p0);
    }
    static public interface RequestBodyUriSpec extends WebClient.RequestBodySpec, WebClient.RequestHeadersUriSpec<WebClient.RequestBodySpec>
    {
    }
    static public interface RequestHeadersSpec<S extends WebClient.RequestHeadersSpec<S>>
    {
        <V> reactor.core.publisher.Flux<V> exchangeToFlux(Function<ClientResponse, ? extends reactor.core.publisher.Flux<V>> p0);
        <V> reactor.core.publisher.Mono<V> exchangeToMono(Function<ClientResponse, ? extends reactor.core.publisher.Mono<V>> p0);
        Mono<ClientResponse> exchange();
        S accept(MediaType... p0);
        S acceptCharset(Charset... p0);
        S attribute(String p0, Object p1);
        S attributes(Consumer<Map<String, Object>> p0);
        S context(Function<Context, Context> p0);
        S cookie(String p0, String p1);
        S cookies(Consumer<MultiValueMap<String, String>> p0);
        S header(String p0, String... p1);
        S headers(Consumer<HttpHeaders> p0);
        S httpRequest(Consumer<ClientHttpRequest> p0);
        S ifModifiedSince(ZonedDateTime p0);
        S ifNoneMatch(String... p0);
        WebClient.ResponseSpec retrieve();
    }
    static public interface RequestHeadersUriSpec<S extends WebClient.RequestHeadersSpec<S>> extends WebClient.RequestHeadersSpec<S>, WebClient.UriSpec<S>
    {
    }
    static public interface ResponseSpec
    {
        <T> reactor.core.publisher.Flux<T> bodyToFlux(java.lang.Class<T> p0);
        <T> reactor.core.publisher.Flux<T> bodyToFlux(org.springframework.core.ParameterizedTypeReference<T> p0);
        <T> reactor.core.publisher.Mono<T> bodyToMono(java.lang.Class<T> p0);
        <T> reactor.core.publisher.Mono<T> bodyToMono(org.springframework.core.ParameterizedTypeReference<T> p0);
        <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<T>> toEntity(java.lang.Class<T> p0);
        <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<T>> toEntity(org.springframework.core.ParameterizedTypeReference<T> p0);
        <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<java.util.List<T>>> toEntityList(java.lang.Class<T> p0);
        <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<java.util.List<T>>> toEntityList(org.springframework.core.ParameterizedTypeReference<T> p0);
        <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<reactor.core.publisher.Flux<T>>> toEntityFlux(BodyExtractor<reactor.core.publisher.Flux<T>, ? super ClientHttpResponse> p0);
        <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<reactor.core.publisher.Flux<T>>> toEntityFlux(java.lang.Class<T> p0);
        <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<reactor.core.publisher.Flux<T>>> toEntityFlux(org.springframework.core.ParameterizedTypeReference<T> p0);
        Mono<ResponseEntity<Void>> toBodilessEntity();
        WebClient.ResponseSpec onRawStatus(IntPredicate p0, Function<ClientResponse, Mono<? extends Throwable>> p1);
        WebClient.ResponseSpec onStatus(Predicate<HttpStatusCode> p0, Function<ClientResponse, Mono<? extends Throwable>> p1);
    }
    static public interface UriSpec<S extends WebClient.RequestHeadersSpec<? extends Object>>
    {
        S uri(Function<UriBuilder, URI> p0);
        S uri(String p0, Function<UriBuilder, URI> p1);
        S uri(String p0, Map<String, ? extends Object> p1);
        S uri(String p0, Object... p1);
        S uri(URI p0);
    }
}
