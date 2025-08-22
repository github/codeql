// Generated automatically from io.netty.handler.codec.http2.Http2HeadersFrame for testing purposes

package io.netty.handler.codec.http2;

import io.netty.handler.codec.http2.Http2Headers;
import io.netty.handler.codec.http2.Http2StreamFrame;

public interface Http2HeadersFrame extends Http2StreamFrame
{
    Http2Headers headers();
    boolean isEndStream();
    int padding();
}
