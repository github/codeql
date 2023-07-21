// Generated automatically from org.springframework.core.codec.Encoder for testing purposes

package org.springframework.core.codec;

import java.util.List;
import java.util.Map;
import org.reactivestreams.Publisher;
import org.springframework.core.ResolvableType;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.core.io.buffer.DataBufferFactory;
import org.springframework.util.MimeType;
import reactor.core.publisher.Flux;

public interface Encoder<T>
{
    Flux<DataBuffer> encode(org.reactivestreams.Publisher<? extends T> p0, DataBufferFactory p1, ResolvableType p2, MimeType p3, Map<String, Object> p4);
    List<MimeType> getEncodableMimeTypes();
    boolean canEncode(ResolvableType p0, MimeType p1);
    default DataBuffer encodeValue(T p0, DataBufferFactory p1, ResolvableType p2, MimeType p3, Map<String, Object> p4){ return null; }
    default List<MimeType> getEncodableMimeTypes(ResolvableType p0){ return null; }
}
