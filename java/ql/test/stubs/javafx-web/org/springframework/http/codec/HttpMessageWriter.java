// Generated automatically from org.springframework.http.codec.HttpMessageWriter for testing purposes

package org.springframework.http.codec;

import java.util.List;
import java.util.Map;
import org.reactivestreams.Publisher;
import org.springframework.core.ResolvableType;
import org.springframework.http.MediaType;
import org.springframework.http.ReactiveHttpOutputMessage;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import reactor.core.publisher.Mono;

public interface HttpMessageWriter<T>
{
    List<MediaType> getWritableMediaTypes();
    Mono<Void> write(org.reactivestreams.Publisher<? extends T> p0, ResolvableType p1, MediaType p2, ReactiveHttpOutputMessage p3, Map<String, Object> p4);
    boolean canWrite(ResolvableType p0, MediaType p1);
    default List<MediaType> getWritableMediaTypes(ResolvableType p0){ return null; }
    default Mono<Void> write(org.reactivestreams.Publisher<? extends T> p0, ResolvableType p1, ResolvableType p2, MediaType p3, ServerHttpRequest p4, ServerHttpResponse p5, Map<String, Object> p6){ return null; }
}
