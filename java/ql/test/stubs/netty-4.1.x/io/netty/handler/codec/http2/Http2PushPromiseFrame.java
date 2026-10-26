// Generated automatically from io.netty.handler.codec.http2.Http2PushPromiseFrame for testing purposes

package io.netty.handler.codec.http2;

import io.netty.handler.codec.http2.Http2FrameStream;
import io.netty.handler.codec.http2.Http2Headers;
import io.netty.handler.codec.http2.Http2StreamFrame;

public interface Http2PushPromiseFrame extends Http2StreamFrame
{
    Http2FrameStream pushStream();
    Http2Headers http2Headers();
    Http2PushPromiseFrame stream(Http2FrameStream p0);
    Http2StreamFrame pushStream(Http2FrameStream p0);
    int padding();
    int promisedStreamId();
}
