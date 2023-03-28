// Generated automatically from org.springframework.web.reactive.function.client.ClientResponse for testing purposes

package org.springframework.web.reactive.function.client;

import java.util.List;
import java.util.Optional;
import java.util.OptionalLong;
import java.util.function.Consumer;
import java.util.function.Function;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.ReactiveHttpInputMessage;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.reactive.ClientHttpResponse;
import org.springframework.http.codec.HttpMessageReader;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyExtractor;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ClientResponse
{
    <T> T body(BodyExtractor<T, ? super ClientHttpResponse> p0);
    <T> reactor.core.publisher.Flux<T> bodyToFlux(java.lang.Class<? extends T> p0);
    <T> reactor.core.publisher.Flux<T> bodyToFlux(org.springframework.core.ParameterizedTypeReference<T> p0);
    <T> reactor.core.publisher.Mono<T> bodyToMono(java.lang.Class<? extends T> p0);
    <T> reactor.core.publisher.Mono<T> bodyToMono(org.springframework.core.ParameterizedTypeReference<T> p0);
    <T> reactor.core.publisher.Mono<T> createError();
    <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<T>> toEntity(java.lang.Class<T> p0);
    <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<T>> toEntity(org.springframework.core.ParameterizedTypeReference<T> p0);
    <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<java.util.List<T>>> toEntityList(java.lang.Class<T> p0);
    <T> reactor.core.publisher.Mono<org.springframework.http.ResponseEntity<java.util.List<T>>> toEntityList(org.springframework.core.ParameterizedTypeReference<T> p0);
    ClientResponse.Headers headers();
    ExchangeStrategies strategies();
    HttpStatusCode statusCode();
    Mono<ResponseEntity<Void>> toBodilessEntity();
    Mono<Void> releaseBody();
    Mono<WebClientResponseException> createException();
    MultiValueMap<String, ResponseCookie> cookies();
    String logPrefix();
    default ClientResponse.Builder mutate(){ return null; }
    default int rawStatusCode(){ return 0; }
    static ClientResponse.Builder create(HttpStatusCode p0){ return null; }
    static ClientResponse.Builder create(HttpStatusCode p0, ExchangeStrategies p1){ return null; }
    static ClientResponse.Builder create(HttpStatusCode p0, List<HttpMessageReader<? extends Object>> p1){ return null; }
    static ClientResponse.Builder create(int p0, ExchangeStrategies p1){ return null; }
    static ClientResponse.Builder from(ClientResponse p0){ return null; }
    static public interface Builder
    {
        ClientResponse build();
        ClientResponse.Builder body(Flux<DataBuffer> p0);
        ClientResponse.Builder body(Function<Flux<DataBuffer>, Flux<DataBuffer>> p0);
        ClientResponse.Builder body(String p0);
        ClientResponse.Builder cookie(String p0, String... p1);
        ClientResponse.Builder cookies(Consumer<MultiValueMap<String, ResponseCookie>> p0);
        ClientResponse.Builder header(String p0, String... p1);
        ClientResponse.Builder headers(Consumer<HttpHeaders> p0);
        ClientResponse.Builder rawStatusCode(int p0);
        ClientResponse.Builder request(HttpRequest p0);
        ClientResponse.Builder statusCode(HttpStatusCode p0);
    }
    static public interface Headers
    {
        HttpHeaders asHttpHeaders();
        List<String> header(String p0);
        Optional<MediaType> contentType();
        OptionalLong contentLength();
    }
}
