// Generated automatically from io.netty.channel.ChannelProgressiveFuture for testing purposes

package io.netty.channel;

import io.netty.channel.ChannelFuture;
import io.netty.util.concurrent.GenericFutureListener;
import io.netty.util.concurrent.ProgressiveFuture;

public interface ChannelProgressiveFuture extends ChannelFuture, ProgressiveFuture<Void>
{
    ChannelProgressiveFuture addListener(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>> p0);
    ChannelProgressiveFuture addListeners(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>>... p0);
    ChannelProgressiveFuture await();
    ChannelProgressiveFuture awaitUninterruptibly();
    ChannelProgressiveFuture removeListener(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>> p0);
    ChannelProgressiveFuture removeListeners(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>>... p0);
    ChannelProgressiveFuture sync();
    ChannelProgressiveFuture syncUninterruptibly();
}
