// Generated automatically from io.netty.channel.ChannelInboundHandler for testing purposes

package io.netty.channel;

import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerContext;

public interface ChannelInboundHandler extends ChannelHandler
{
    void channelActive(ChannelHandlerContext p0);
    void channelInactive(ChannelHandlerContext p0);
    void channelRead(ChannelHandlerContext p0, Object p1);
    void channelReadComplete(ChannelHandlerContext p0);
    void channelRegistered(ChannelHandlerContext p0);
    void channelUnregistered(ChannelHandlerContext p0);
    void channelWritabilityChanged(ChannelHandlerContext p0);
    void exceptionCaught(ChannelHandlerContext p0, Throwable p1);
    void userEventTriggered(ChannelHandlerContext p0, Object p1);
}
