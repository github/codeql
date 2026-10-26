// Generated automatically from io.netty.handler.codec.http2.Http2FrameAdapter for testing purposes

package io.netty.handler.codec.http2;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http2.Http2Flags;
import io.netty.handler.codec.http2.Http2FrameListener;
import io.netty.handler.codec.http2.Http2Headers;
import io.netty.handler.codec.http2.Http2Settings;

public class Http2FrameAdapter implements Http2FrameListener
{
    public Http2FrameAdapter(){}
    public int onDataRead(ChannelHandlerContext p0, int p1, ByteBuf p2, int p3, boolean p4){ return 0; }
    public void onGoAwayRead(ChannelHandlerContext p0, int p1, long p2, ByteBuf p3){}
    public void onHeadersRead(ChannelHandlerContext p0, int p1, Http2Headers p2, int p3, boolean p4){}
    public void onHeadersRead(ChannelHandlerContext p0, int p1, Http2Headers p2, int p3, short p4, boolean p5, int p6, boolean p7){}
    public void onPingAckRead(ChannelHandlerContext p0, long p1){}
    public void onPingRead(ChannelHandlerContext p0, long p1){}
    public void onPriorityRead(ChannelHandlerContext p0, int p1, int p2, short p3, boolean p4){}
    public void onPushPromiseRead(ChannelHandlerContext p0, int p1, int p2, Http2Headers p3, int p4){}
    public void onRstStreamRead(ChannelHandlerContext p0, int p1, long p2){}
    public void onSettingsAckRead(ChannelHandlerContext p0){}
    public void onSettingsRead(ChannelHandlerContext p0, Http2Settings p1){}
    public void onUnknownFrame(ChannelHandlerContext p0, byte p1, int p2, Http2Flags p3, ByteBuf p4){}
    public void onWindowUpdateRead(ChannelHandlerContext p0, int p1, int p2){}
}
