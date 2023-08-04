// Generated automatically from io.netty.handler.codec.http2.Http2LocalFlowController for testing purposes

package io.netty.handler.codec.http2;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http2.Http2FlowController;
import io.netty.handler.codec.http2.Http2FrameWriter;
import io.netty.handler.codec.http2.Http2Stream;

public interface Http2LocalFlowController extends Http2FlowController
{
    Http2LocalFlowController frameWriter(Http2FrameWriter p0);
    boolean consumeBytes(Http2Stream p0, int p1);
    int initialWindowSize(Http2Stream p0);
    int unconsumedBytes(Http2Stream p0);
    void receiveFlowControlledFrame(Http2Stream p0, ByteBuf p1, int p2, boolean p3);
}
