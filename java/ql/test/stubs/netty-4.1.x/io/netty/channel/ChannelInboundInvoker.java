// Generated automatically from io.netty.channel.ChannelInboundInvoker for testing purposes

package io.netty.channel;


public interface ChannelInboundInvoker
{
    ChannelInboundInvoker fireChannelActive();
    ChannelInboundInvoker fireChannelInactive();
    ChannelInboundInvoker fireChannelRead(Object p0);
    ChannelInboundInvoker fireChannelReadComplete();
    ChannelInboundInvoker fireChannelRegistered();
    ChannelInboundInvoker fireChannelUnregistered();
    ChannelInboundInvoker fireChannelWritabilityChanged();
    ChannelInboundInvoker fireExceptionCaught(Throwable p0);
    ChannelInboundInvoker fireUserEventTriggered(Object p0);
}
