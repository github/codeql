// Generated automatically from org.springframework.http.codec.CodecConfigurer for testing purposes

package org.springframework.http.codec;

import java.util.List;
import java.util.function.Consumer;
import org.springframework.core.codec.Decoder;
import org.springframework.core.codec.Encoder;
import org.springframework.http.codec.HttpMessageReader;
import org.springframework.http.codec.HttpMessageWriter;

public interface CodecConfigurer
{
    CodecConfigurer clone();
    CodecConfigurer.CustomCodecs customCodecs();
    CodecConfigurer.DefaultCodecs defaultCodecs();
    List<HttpMessageReader<? extends Object>> getReaders();
    List<HttpMessageWriter<? extends Object>> getWriters();
    static public interface CustomCodecs
    {
        void decoder(Decoder<? extends Object> p0);
        void encoder(Encoder<? extends Object> p0);
        void reader(HttpMessageReader<? extends Object> p0);
        void register(Object p0);
        void registerWithDefaultConfig(Object p0);
        void registerWithDefaultConfig(Object p0, Consumer<CodecConfigurer.DefaultCodecConfig> p1);
        void withDefaultCodecConfig(Consumer<CodecConfigurer.DefaultCodecConfig> p0);
        void writer(HttpMessageWriter<? extends Object> p0);
    }
    static public interface DefaultCodecConfig
    {
        Boolean isEnableLoggingRequestDetails();
        Integer maxInMemorySize();
    }
    static public interface DefaultCodecs
    {
        void configureDefaultCodec(Consumer<Object> p0);
        void enableLoggingRequestDetails(boolean p0);
        void jackson2JsonDecoder(Decoder<? extends Object> p0);
        void jackson2JsonEncoder(Encoder<? extends Object> p0);
        void jackson2SmileDecoder(Decoder<? extends Object> p0);
        void jackson2SmileEncoder(Encoder<? extends Object> p0);
        void jaxb2Decoder(Decoder<? extends Object> p0);
        void jaxb2Encoder(Encoder<? extends Object> p0);
        void kotlinSerializationJsonDecoder(Decoder<? extends Object> p0);
        void kotlinSerializationJsonEncoder(Encoder<? extends Object> p0);
        void maxInMemorySize(int p0);
        void protobufDecoder(Decoder<? extends Object> p0);
        void protobufEncoder(Encoder<? extends Object> p0);
    }
    void registerDefaults(boolean p0);
}
