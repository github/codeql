// Generated automatically from org.springframework.web.reactive.function.client.ExchangeFilterFunction for testing purposes

package org.springframework.web.reactive.function.client;

import java.util.function.Function;
import org.springframework.web.reactive.function.client.ClientRequest;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.ExchangeFunction;
import reactor.core.publisher.Mono;

public interface ExchangeFilterFunction
{
    Mono<ClientResponse> filter(ClientRequest p0, ExchangeFunction p1);
    default ExchangeFilterFunction andThen(ExchangeFilterFunction p0){ return null; }
    default ExchangeFunction apply(ExchangeFunction p0){ return null; }
    static ExchangeFilterFunction ofRequestProcessor(Function<ClientRequest, Mono<ClientRequest>> p0){ return null; }
    static ExchangeFilterFunction ofResponseProcessor(Function<ClientResponse, Mono<ClientResponse>> p0){ return null; }
}
