// Generated automatically from org.springframework.core.codec.Decoder for testing purposes

package org.springframework.core.codec;

import java.util.List;
import java.util.Map;
import org.reactivestreams.Publisher;
import org.springframework.core.ResolvableType;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.util.MimeType;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface Decoder<T>
{
    List<MimeType> getDecodableMimeTypes();
    boolean canDecode(ResolvableType p0, MimeType p1);
    default List<MimeType> getDecodableMimeTypes(ResolvableType p0){ return null; }
    default T decode(DataBuffer p0, ResolvableType p1, MimeType p2, Map<String, Object> p3){ return null; }
    reactor.core.publisher.Flux<T> decode(Publisher<DataBuffer> p0, ResolvableType p1, MimeType p2, Map<String, Object> p3);
    reactor.core.publisher.Mono<T> decodeToMono(Publisher<DataBuffer> p0, ResolvableType p1, MimeType p2, Map<String, Object> p3);
}
