// Generated automatically from io.netty.channel.ChannelProgressivePromise for testing purposes

package io.netty.channel;

import io.netty.channel.ChannelProgressiveFuture;
import io.netty.channel.ChannelPromise;
import io.netty.util.concurrent.GenericFutureListener;
import io.netty.util.concurrent.ProgressivePromise;

public interface ChannelProgressivePromise extends ChannelProgressiveFuture, ChannelPromise, ProgressivePromise<Void>
{
    ChannelProgressivePromise addListener(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>> p0);
    ChannelProgressivePromise addListeners(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>>... p0);
    ChannelProgressivePromise await();
    ChannelProgressivePromise awaitUninterruptibly();
    ChannelProgressivePromise removeListener(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>> p0);
    ChannelProgressivePromise removeListeners(GenericFutureListener<? extends io.netty.util.concurrent.Future<? super Void>>... p0);
    ChannelProgressivePromise setFailure(Throwable p0);
    ChannelProgressivePromise setProgress(long p0, long p1);
    ChannelProgressivePromise setSuccess();
    ChannelProgressivePromise setSuccess(Void p0);
    ChannelProgressivePromise sync();
    ChannelProgressivePromise syncUninterruptibly();
    ChannelProgressivePromise unvoid();
}
