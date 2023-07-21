// Generated automatically from io.netty.channel.ChannelPipeline for testing purposes

package io.netty.channel;

import io.netty.channel.Channel;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundInvoker;
import io.netty.channel.ChannelOutboundInvoker;
import io.netty.util.concurrent.EventExecutorGroup;
import java.util.List;
import java.util.Map;

public interface ChannelPipeline extends ChannelInboundInvoker, ChannelOutboundInvoker, Iterable<Map.Entry<String, ChannelHandler>>
{
    <T extends ChannelHandler> T get(java.lang.Class<T> p0);
    <T extends ChannelHandler> T remove(java.lang.Class<T> p0);
    <T extends ChannelHandler> T replace(java.lang.Class<T> p0, String p1, ChannelHandler p2);
    Channel channel();
    ChannelHandler first();
    ChannelHandler get(String p0);
    ChannelHandler last();
    ChannelHandler remove(String p0);
    ChannelHandler removeFirst();
    ChannelHandler removeLast();
    ChannelHandler replace(String p0, String p1, ChannelHandler p2);
    ChannelHandlerContext context(ChannelHandler p0);
    ChannelHandlerContext context(Class<? extends ChannelHandler> p0);
    ChannelHandlerContext context(String p0);
    ChannelHandlerContext firstContext();
    ChannelHandlerContext lastContext();
    ChannelPipeline addAfter(EventExecutorGroup p0, String p1, String p2, ChannelHandler p3);
    ChannelPipeline addAfter(String p0, String p1, ChannelHandler p2);
    ChannelPipeline addBefore(EventExecutorGroup p0, String p1, String p2, ChannelHandler p3);
    ChannelPipeline addBefore(String p0, String p1, ChannelHandler p2);
    ChannelPipeline addFirst(ChannelHandler... p0);
    ChannelPipeline addFirst(EventExecutorGroup p0, ChannelHandler... p1);
    ChannelPipeline addFirst(EventExecutorGroup p0, String p1, ChannelHandler p2);
    ChannelPipeline addFirst(String p0, ChannelHandler p1);
    ChannelPipeline addLast(ChannelHandler... p0);
    ChannelPipeline addLast(EventExecutorGroup p0, ChannelHandler... p1);
    ChannelPipeline addLast(EventExecutorGroup p0, String p1, ChannelHandler p2);
    ChannelPipeline addLast(String p0, ChannelHandler p1);
    ChannelPipeline fireChannelActive();
    ChannelPipeline fireChannelInactive();
    ChannelPipeline fireChannelRead(Object p0);
    ChannelPipeline fireChannelReadComplete();
    ChannelPipeline fireChannelRegistered();
    ChannelPipeline fireChannelUnregistered();
    ChannelPipeline fireChannelWritabilityChanged();
    ChannelPipeline fireExceptionCaught(Throwable p0);
    ChannelPipeline fireUserEventTriggered(Object p0);
    ChannelPipeline flush();
    ChannelPipeline remove(ChannelHandler p0);
    ChannelPipeline replace(ChannelHandler p0, String p1, ChannelHandler p2);
    List<String> names();
    Map<String, ChannelHandler> toMap();
}
