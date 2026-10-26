// Generated automatically from org.springframework.web.reactive.function.client.ClientRequest for testing purposes

package org.springframework.web.reactive.function.client;

import java.net.URI;
import java.util.Map;
import java.util.Optional;
import java.util.function.Consumer;
import org.reactivestreams.Publisher;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ReactiveHttpOutputMessage;
import org.springframework.http.client.reactive.ClientHttpRequest;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserter;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import reactor.core.publisher.Mono;

public interface ClientRequest
{
    BodyInserter<? extends Object, ? super ClientHttpRequest> body();
    Consumer<ClientHttpRequest> httpRequest();
    HttpHeaders headers();
    HttpMethod method();
    Map<String, Object> attributes();
    Mono<Void> writeTo(ClientHttpRequest p0, ExchangeStrategies p1);
    MultiValueMap<String, String> cookies();
    String logPrefix();
    URI url();
    default Optional<Object> attribute(String p0){ return null; }
    static ClientRequest.Builder create(HttpMethod p0, URI p1){ return null; }
    static ClientRequest.Builder from(ClientRequest p0){ return null; }
    static ClientRequest.Builder method(HttpMethod p0, URI p1){ return null; }
    static String LOG_ID_ATTRIBUTE = null;
    static public interface Builder
    {
        <S, P extends org.reactivestreams.Publisher<S>> ClientRequest.Builder body(P p0, ParameterizedTypeReference<S> p1);
        <S, P extends org.reactivestreams.Publisher<S>> ClientRequest.Builder body(P p0, java.lang.Class<S> p1);
        ClientRequest build();
        ClientRequest.Builder attribute(String p0, Object p1);
        ClientRequest.Builder attributes(Consumer<Map<String, Object>> p0);
        ClientRequest.Builder body(BodyInserter<? extends Object, ? super ClientHttpRequest> p0);
        ClientRequest.Builder cookie(String p0, String... p1);
        ClientRequest.Builder cookies(Consumer<MultiValueMap<String, String>> p0);
        ClientRequest.Builder header(String p0, String... p1);
        ClientRequest.Builder headers(Consumer<HttpHeaders> p0);
        ClientRequest.Builder httpRequest(Consumer<ClientHttpRequest> p0);
        ClientRequest.Builder method(HttpMethod p0);
        ClientRequest.Builder url(URI p0);
    }
}
