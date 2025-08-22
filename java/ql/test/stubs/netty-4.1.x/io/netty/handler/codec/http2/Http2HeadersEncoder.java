// Generated automatically from io.netty.handler.codec.http2.Http2HeadersEncoder for testing purposes

package io.netty.handler.codec.http2;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http2.Http2Headers;

public interface Http2HeadersEncoder
{
    Http2HeadersEncoder.Configuration configuration();
    static Http2HeadersEncoder.SensitivityDetector ALWAYS_SENSITIVE = null;
    static Http2HeadersEncoder.SensitivityDetector NEVER_SENSITIVE = null;
    static public interface Configuration
    {
        long maxHeaderListSize();
        long maxHeaderTableSize();
        void maxHeaderListSize(long p0);
        void maxHeaderTableSize(long p0);
    }
    static public interface SensitivityDetector
    {
        boolean isSensitive(CharSequence p0, CharSequence p1);
    }
    void encodeHeaders(int p0, Http2Headers p1, ByteBuf p2);
}
