// Generated automatically from org.springframework.web.reactive.function.BodyInserter for testing purposes

package org.springframework.web.reactive.function;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.springframework.http.ReactiveHttpOutputMessage;
import org.springframework.http.codec.HttpMessageWriter;
import org.springframework.http.server.reactive.ServerHttpRequest;
import reactor.core.publisher.Mono;

public interface BodyInserter<T, M extends ReactiveHttpOutputMessage>
{
    Mono<Void> insert(M p0, BodyInserter.Context p1);
    static public interface Context
    {
        List<HttpMessageWriter<? extends Object>> messageWriters();
        Map<String, Object> hints();
        Optional<ServerHttpRequest> serverRequest();
    }
}
