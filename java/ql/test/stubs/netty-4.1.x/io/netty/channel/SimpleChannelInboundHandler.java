// Generated automatically from io.netty.channel.SimpleChannelInboundHandler for testing purposes

package io.netty.channel;

import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;

abstract public class SimpleChannelInboundHandler<I> extends ChannelInboundHandlerAdapter
{
    protected SimpleChannelInboundHandler(){}
    protected SimpleChannelInboundHandler(Class<? extends I> p0){}
    protected SimpleChannelInboundHandler(Class<? extends I> p0, boolean p1){}
    protected SimpleChannelInboundHandler(boolean p0){}
    protected abstract void channelRead0(ChannelHandlerContext p0, I p1);
    public boolean acceptInboundMessage(Object p0){ return false; }
    public void channelRead(ChannelHandlerContext p0, Object p1){}
}
