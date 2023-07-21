// Generated automatically from org.springframework.http.ReactiveHttpInputMessage for testing purposes

package org.springframework.http;

import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpMessage;
import reactor.core.publisher.Flux;

public interface ReactiveHttpInputMessage extends HttpMessage
{
    Flux<DataBuffer> getBody();
}
