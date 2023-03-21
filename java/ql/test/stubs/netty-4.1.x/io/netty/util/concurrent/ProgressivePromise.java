// Generated automatically from io.netty.util.concurrent.ProgressivePromise for testing purposes

package io.netty.util.concurrent;

import io.netty.util.concurrent.GenericFutureListener;
import io.netty.util.concurrent.ProgressiveFuture;
import io.netty.util.concurrent.Promise;

public interface ProgressivePromise<V> extends io.netty.util.concurrent.ProgressiveFuture<V>, io.netty.util.concurrent.Promise<V>
{
    ProgressivePromise<V> addListener(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>> p0);
    ProgressivePromise<V> addListeners(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>>... p0);
    ProgressivePromise<V> await();
    ProgressivePromise<V> awaitUninterruptibly();
    ProgressivePromise<V> removeListener(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>> p0);
    ProgressivePromise<V> removeListeners(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>>... p0);
    ProgressivePromise<V> setFailure(Throwable p0);
    ProgressivePromise<V> setProgress(long p0, long p1);
    ProgressivePromise<V> setSuccess(V p0);
    ProgressivePromise<V> sync();
    ProgressivePromise<V> syncUninterruptibly();
    boolean tryProgress(long p0, long p1);
}
