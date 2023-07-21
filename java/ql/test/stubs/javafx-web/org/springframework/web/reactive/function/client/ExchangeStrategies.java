// Generated automatically from org.springframework.web.reactive.function.client.ExchangeStrategies for testing purposes

package org.springframework.web.reactive.function.client;

import java.util.List;
import java.util.function.Consumer;
import org.springframework.http.codec.ClientCodecConfigurer;
import org.springframework.http.codec.HttpMessageReader;
import org.springframework.http.codec.HttpMessageWriter;

public interface ExchangeStrategies
{
    List<HttpMessageReader<? extends Object>> messageReaders();
    List<HttpMessageWriter<? extends Object>> messageWriters();
    default ExchangeStrategies.Builder mutate(){ return null; }
    static ExchangeStrategies withDefaults(){ return null; }
    static ExchangeStrategies.Builder builder(){ return null; }
    static ExchangeStrategies.Builder empty(){ return null; }
    static public interface Builder
    {
        ExchangeStrategies build();
        ExchangeStrategies.Builder codecs(Consumer<ClientCodecConfigurer> p0);
    }
}
