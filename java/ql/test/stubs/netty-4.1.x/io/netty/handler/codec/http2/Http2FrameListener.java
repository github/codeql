// Generated automatically from io.netty.handler.codec.http2.Http2FrameListener for testing purposes

package io.netty.handler.codec.http2;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http2.Http2Flags;
import io.netty.handler.codec.http2.Http2Headers;
import io.netty.handler.codec.http2.Http2Settings;

public interface Http2FrameListener
{
    int onDataRead(ChannelHandlerContext p0, int p1, ByteBuf p2, int p3, boolean p4);
    void onGoAwayRead(ChannelHandlerContext p0, int p1, long p2, ByteBuf p3);
    void onHeadersRead(ChannelHandlerContext p0, int p1, Http2Headers p2, int p3, boolean p4);
    void onHeadersRead(ChannelHandlerContext p0, int p1, Http2Headers p2, int p3, short p4, boolean p5, int p6, boolean p7);
    void onPingAckRead(ChannelHandlerContext p0, long p1);
    void onPingRead(ChannelHandlerContext p0, long p1);
    void onPriorityRead(ChannelHandlerContext p0, int p1, int p2, short p3, boolean p4);
    void onPushPromiseRead(ChannelHandlerContext p0, int p1, int p2, Http2Headers p3, int p4);
    void onRstStreamRead(ChannelHandlerContext p0, int p1, long p2);
    void onSettingsAckRead(ChannelHandlerContext p0);
    void onSettingsRead(ChannelHandlerContext p0, Http2Settings p1);
    void onUnknownFrame(ChannelHandlerContext p0, byte p1, int p2, Http2Flags p3, ByteBuf p4);
    void onWindowUpdateRead(ChannelHandlerContext p0, int p1, int p2);
}
