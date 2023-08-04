// Generated automatically from io.netty.util.concurrent.Future for testing purposes

package io.netty.util.concurrent;

import io.netty.util.concurrent.GenericFutureListener;
import java.util.concurrent.TimeUnit;

public interface Future<V> extends java.util.concurrent.Future<V>
{
    Throwable cause();
    V getNow();
    boolean await(long p0);
    boolean await(long p0, TimeUnit p1);
    boolean awaitUninterruptibly(long p0);
    boolean awaitUninterruptibly(long p0, TimeUnit p1);
    boolean cancel(boolean p0);
    boolean isCancellable();
    boolean isSuccess();
    io.netty.util.concurrent.Future<V> addListener(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>> p0);
    io.netty.util.concurrent.Future<V> addListeners(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>>... p0);
    io.netty.util.concurrent.Future<V> await();
    io.netty.util.concurrent.Future<V> awaitUninterruptibly();
    io.netty.util.concurrent.Future<V> removeListener(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>> p0);
    io.netty.util.concurrent.Future<V> removeListeners(io.netty.util.concurrent.GenericFutureListener<? extends io.netty.util.concurrent.Future<? super V>>... p0);
    io.netty.util.concurrent.Future<V> sync();
    io.netty.util.concurrent.Future<V> syncUninterruptibly();
}
