// Generated automatically from org.springframework.http.client.reactive.ClientHttpConnector for testing purposes

package org.springframework.http.client.reactive;

import java.net.URI;
import java.util.function.Function;
import org.springframework.http.HttpMethod;
import org.springframework.http.client.reactive.ClientHttpRequest;
import org.springframework.http.client.reactive.ClientHttpResponse;
import reactor.core.publisher.Mono;

public interface ClientHttpConnector
{
    Mono<ClientHttpResponse> connect(HttpMethod p0, URI p1, Function<? super ClientHttpRequest, Mono<Void>> p2);
}
