// Generated automatically from io.netty.handler.codec.http2.Http2FlowController for testing purposes

package io.netty.handler.codec.http2;

import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http2.Http2Stream;

public interface Http2FlowController
{
    int initialWindowSize();
    int windowSize(Http2Stream p0);
    void channelHandlerContext(ChannelHandlerContext p0);
    void incrementWindowSize(Http2Stream p0, int p1);
    void initialWindowSize(int p0);
}
