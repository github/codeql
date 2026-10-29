// Generated automatically from io.netty.channel.ChannelHandlerContext for testing purposes

package io.netty.channel;

import io.netty.buffer.ByteBufAllocator;
import io.netty.channel.Channel;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelInboundInvoker;
import io.netty.channel.ChannelOutboundInvoker;
import io.netty.channel.ChannelPipeline;
import io.netty.util.Attribute;
import io.netty.util.AttributeKey;
import io.netty.util.AttributeMap;
import io.netty.util.concurrent.EventExecutor;

public interface ChannelHandlerContext extends AttributeMap, ChannelInboundInvoker, ChannelOutboundInvoker
{
    <T> boolean hasAttr(io.netty.util.AttributeKey<T> p0);
    <T> io.netty.util.Attribute<T> attr(io.netty.util.AttributeKey<T> p0);
    ByteBufAllocator alloc();
    Channel channel();
    ChannelHandler handler();
    ChannelHandlerContext fireChannelActive();
    ChannelHandlerContext fireChannelInactive();
    ChannelHandlerContext fireChannelRead(Object p0);
    ChannelHandlerContext fireChannelReadComplete();
    ChannelHandlerContext fireChannelRegistered();
    ChannelHandlerContext fireChannelUnregistered();
    ChannelHandlerContext fireChannelWritabilityChanged();
    ChannelHandlerContext fireExceptionCaught(Throwable p0);
    ChannelHandlerContext fireUserEventTriggered(Object p0);
    ChannelHandlerContext flush();
    ChannelHandlerContext read();
    ChannelPipeline pipeline();
    EventExecutor executor();
    String name();
    boolean isRemoved();
}
