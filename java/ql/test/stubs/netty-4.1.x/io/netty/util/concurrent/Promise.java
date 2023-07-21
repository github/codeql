// Generated automatically from io.netty.util.concurrent.Promise for testing purposes

package io.netty.util.concurrent;

import io.netty.util.concurrent.GenericFutureListener;

public interface Promise<V> extends io.netty.util.concurrent.Future<V>
{
    Promise<V> addListener(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>> p0);
    Promise<V> addListeners(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>>... p0);
    Promise<V> await();
    Promise<V> awaitUninterruptibly();
    Promise<V> removeListener(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>> p0);
    Promise<V> removeListeners(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>>... p0);
    Promise<V> setFailure(Throwable p0);
    Promise<V> setSuccess(V p0);
    Promise<V> sync();
    Promise<V> syncUninterruptibly();
    boolean setUncancellable();
    boolean tryFailure(Throwable p0);
    boolean trySuccess(V p0);
}
