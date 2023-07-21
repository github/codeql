// Generated automatically from org.springframework.web.reactive.function.BodyExtractor for testing purposes

package org.springframework.web.reactive.function;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.springframework.http.ReactiveHttpInputMessage;
import org.springframework.http.codec.HttpMessageReader;
import org.springframework.http.server.reactive.ServerHttpResponse;

public interface BodyExtractor<T, M extends ReactiveHttpInputMessage>
{
    T extract(M p0, BodyExtractor.Context p1);
    static public interface Context
    {
        List<HttpMessageReader<? extends Object>> messageReaders();
        Map<String, Object> hints();
        Optional<ServerHttpResponse> serverResponse();
    }
}
