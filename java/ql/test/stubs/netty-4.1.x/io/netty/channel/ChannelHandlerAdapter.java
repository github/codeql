// Generated automatically from io.netty.channel.ChannelHandlerAdapter for testing purposes

package io.netty.channel;

import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerContext;

abstract public class ChannelHandlerAdapter implements ChannelHandler
{
    protected void ensureNotSharable(){}
    public ChannelHandlerAdapter(){}
    public boolean isSharable(){ return false; }
    public void exceptionCaught(ChannelHandlerContext p0, Throwable p1){}
    public void handlerAdded(ChannelHandlerContext p0){}
    public void handlerRemoved(ChannelHandlerContext p0){}
}
