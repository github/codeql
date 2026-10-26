// Generated automatically from org.springframework.http.ReactiveHttpOutputMessage for testing purposes

package org.springframework.http;

import java.util.function.Supplier;
import org.reactivestreams.Publisher;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.core.io.buffer.DataBufferFactory;
import org.springframework.http.HttpMessage;
import reactor.core.publisher.Mono;

public interface ReactiveHttpOutputMessage extends HttpMessage
{
    DataBufferFactory bufferFactory();
    Mono<Void> setComplete();
    Mono<Void> writeAndFlushWith(Publisher<? extends Publisher<? extends DataBuffer>> p0);
    Mono<Void> writeWith(Publisher<? extends DataBuffer> p0);
    boolean isCommitted();
    void beforeCommit(Supplier<? extends Mono<Void>> p0);
}
