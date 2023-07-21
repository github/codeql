// Generated automatically from io.netty.util.concurrent.ProgressiveFuture for testing purposes

package io.netty.util.concurrent;

import io.netty.util.concurrent.GenericFutureListener;

public interface ProgressiveFuture<V> extends io.netty.util.concurrent.Future<V>
{
    ProgressiveFuture<V> addListener(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>> p0);
    ProgressiveFuture<V> addListeners(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>>... p0);
    ProgressiveFuture<V> await();
    ProgressiveFuture<V> awaitUninterruptibly();
    ProgressiveFuture<V> removeListener(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>> p0);
    ProgressiveFuture<V> removeListeners(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>>... p0);
    ProgressiveFuture<V> sync();
    ProgressiveFuture<V> syncUninterruptibly();
}
