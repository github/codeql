// Generated automatically from org.springframework.web.reactive.function.client.ExchangeFunction for testing purposes

package org.springframework.web.reactive.function.client;

import org.springframework.web.reactive.function.client.ClientRequest;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.ExchangeFilterFunction;
import reactor.core.publisher.Mono;

public interface ExchangeFunction
{
    Mono<ClientResponse> exchange(ClientRequest p0);
    default ExchangeFunction filter(ExchangeFilterFunction p0){ return null; }
}
