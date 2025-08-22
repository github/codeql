// Generated automatically from io.netty.handler.codec.http2.Http2FrameWriter for testing purposes

package io.netty.handler.codec.http2;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelPromise;
import io.netty.handler.codec.http2.Http2DataWriter;
import io.netty.handler.codec.http2.Http2Flags;
import io.netty.handler.codec.http2.Http2FrameSizePolicy;
import io.netty.handler.codec.http2.Http2Headers;
import io.netty.handler.codec.http2.Http2HeadersEncoder;
import io.netty.handler.codec.http2.Http2Settings;
import java.io.Closeable;

public interface Http2FrameWriter extends Closeable, Http2DataWriter
{
    ChannelFuture writeFrame(ChannelHandlerContext p0, byte p1, int p2, Http2Flags p3, ByteBuf p4, ChannelPromise p5);
    ChannelFuture writeGoAway(ChannelHandlerContext p0, int p1, long p2, ByteBuf p3, ChannelPromise p4);
    ChannelFuture writeHeaders(ChannelHandlerContext p0, int p1, Http2Headers p2, int p3, boolean p4, ChannelPromise p5);
    ChannelFuture writeHeaders(ChannelHandlerContext p0, int p1, Http2Headers p2, int p3, short p4, boolean p5, int p6, boolean p7, ChannelPromise p8);
    ChannelFuture writePing(ChannelHandlerContext p0, boolean p1, long p2, ChannelPromise p3);
    ChannelFuture writePriority(ChannelHandlerContext p0, int p1, int p2, short p3, boolean p4, ChannelPromise p5);
    ChannelFuture writePushPromise(ChannelHandlerContext p0, int p1, int p2, Http2Headers p3, int p4, ChannelPromise p5);
    ChannelFuture writeRstStream(ChannelHandlerContext p0, int p1, long p2, ChannelPromise p3);
    ChannelFuture writeSettings(ChannelHandlerContext p0, Http2Settings p1, ChannelPromise p2);
    ChannelFuture writeSettingsAck(ChannelHandlerContext p0, ChannelPromise p1);
    ChannelFuture writeWindowUpdate(ChannelHandlerContext p0, int p1, int p2, ChannelPromise p3);
    Http2FrameWriter.Configuration configuration();
    static public interface Configuration
    {
        Http2FrameSizePolicy frameSizePolicy();
        Http2HeadersEncoder.Configuration headersConfiguration();
    }
    void close();
}
