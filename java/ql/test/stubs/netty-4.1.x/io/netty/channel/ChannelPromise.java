// Generated automatically from io.netty.channel.ChannelPromise for testing purposes

package io.netty.channel;

import io.netty.channel.Channel;
import io.netty.channel.ChannelFuture;
import io.netty.util.concurrent.GenericFutureListener;
import io.netty.util.concurrent.Promise;

public interface ChannelPromise extends ChannelFuture, Promise<Void>
{
    Channel channel();
    ChannelPromise addListener(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>> p0);
    ChannelPromise addListeners(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>>... p0);
    ChannelPromise await();
    ChannelPromise awaitUninterruptibly();
    ChannelPromise removeListener(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>> p0);
    ChannelPromise removeListeners(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>>... p0);
    ChannelPromise setFailure(Throwable p0);
    ChannelPromise setSuccess();
    ChannelPromise setSuccess(Void p0);
    ChannelPromise sync();
    ChannelPromise syncUninterruptibly();
    ChannelPromise unvoid();
    boolean trySuccess();
}
