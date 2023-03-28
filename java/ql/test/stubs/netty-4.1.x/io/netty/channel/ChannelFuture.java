// Generated automatically from io.netty.channel.ChannelFuture for testing purposes

package io.netty.channel;

import io.netty.channel.Channel;
import io.netty.util.concurrent.GenericFutureListener;

public interface ChannelFuture extends io.netty.util.concurrent.Future<Void>
{
    Channel channel();
    ChannelFuture addListener(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>> p0);
    ChannelFuture addListeners(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>>... p0);
    ChannelFuture await();
    ChannelFuture awaitUninterruptibly();
    ChannelFuture removeListener(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>> p0);
    ChannelFuture removeListeners(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>>... p0);
    ChannelFuture sync();
    ChannelFuture syncUninterruptibly();
    boolean isVoid();
}
