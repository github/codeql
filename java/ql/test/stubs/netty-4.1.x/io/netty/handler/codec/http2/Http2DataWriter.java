// Generated automatically from io.netty.handler.codec.http2.Http2DataWriter for testing purposes

package io.netty.handler.codec.http2;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelPromise;

public interface Http2DataWriter
{
    ChannelFuture writeData(ChannelHandlerContext p0, int p1, ByteBuf p2, int p3, boolean p4, ChannelPromise p5);
}
