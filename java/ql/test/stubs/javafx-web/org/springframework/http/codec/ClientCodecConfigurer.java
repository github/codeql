// Generated automatically from org.springframework.http.codec.ClientCodecConfigurer for testing purposes

package org.springframework.http.codec;

import org.springframework.core.codec.Decoder;
import org.springframework.core.codec.Encoder;
import org.springframework.http.codec.CodecConfigurer;
import org.springframework.http.codec.HttpMessageWriter;

public interface ClientCodecConfigurer extends CodecConfigurer
{
    ClientCodecConfigurer clone();
    ClientCodecConfigurer.ClientDefaultCodecs defaultCodecs();
    static ClientCodecConfigurer create(){ return null; }
    static public interface ClientDefaultCodecs extends CodecConfigurer.DefaultCodecs
    {
        ClientCodecConfigurer.MultipartCodecs multipartCodecs();
        void serverSentEventDecoder(Decoder<? extends Object> p0);
    }
    static public interface MultipartCodecs
    {
        ClientCodecConfigurer.MultipartCodecs encoder(Encoder<? extends Object> p0);
        ClientCodecConfigurer.MultipartCodecs writer(HttpMessageWriter<? extends Object> p0);
    }
}
