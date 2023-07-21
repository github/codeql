// Generated automatically from org.springframework.http.codec.HttpMessageReader for testing purposes

package org.springframework.http.codec;

import java.util.List;
import java.util.Map;
import org.springframework.core.ResolvableType;
import org.springframework.http.MediaType;
import org.springframework.http.ReactiveHttpInputMessage;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface HttpMessageReader<T>
{
    List<MediaType> getReadableMediaTypes();
    boolean canRead(ResolvableType p0, MediaType p1);
    default List<MediaType> getReadableMediaTypes(ResolvableType p0){ return null; }
    default reactor.core.publisher.Flux<T> read(ResolvableType p0, ResolvableType p1, ServerHttpRequest p2, ServerHttpResponse p3, Map<String, Object> p4){ return null; }
    default reactor.core.publisher.Mono<T> readMono(ResolvableType p0, ResolvableType p1, ServerHttpRequest p2, ServerHttpResponse p3, Map<String, Object> p4){ return null; }
    reactor.core.publisher.Flux<T> read(ResolvableType p0, ReactiveHttpInputMessage p1, Map<String, Object> p2);
    reactor.core.publisher.Mono<T> readMono(ResolvableType p0, ReactiveHttpInputMessage p1, Map<String, Object> p2);
}
