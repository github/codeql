// Generated automatically from io.netty.handler.codec.http2.Http2StreamFrame for testing purposes

package io.netty.handler.codec.http2;

import io.netty.handler.codec.http2.Http2Frame;
import io.netty.handler.codec.http2.Http2FrameStream;

public interface Http2StreamFrame extends Http2Frame
{
    Http2FrameStream stream();
    Http2StreamFrame stream(Http2FrameStream p0);
}
