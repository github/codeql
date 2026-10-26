// Generated automatically from io.netty.util.concurrent.EventExecutorGroup for testing purposes

package io.netty.util.concurrent;

import io.netty.util.concurrent.EventExecutor;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public interface EventExecutorGroup extends Iterable<EventExecutor>, ScheduledExecutorService
{
    <T> io.netty.util.concurrent.Future<T> submit(Runnable p0, T p1);
    <T> io.netty.util.concurrent.Future<T> submit(java.util.concurrent.Callable<T> p0);
    <V> io.netty.util.concurrent.ScheduledFuture<V> schedule(java.util.concurrent.Callable<V> p0, long p1, TimeUnit p2);
    EventExecutor next();
    Iterator<EventExecutor> iterator();
    List<Runnable> shutdownNow();
    boolean isShuttingDown();
    io.netty.util.concurrent.Future<? extends Object> shutdownGracefully();
    io.netty.util.concurrent.Future<? extends Object> shutdownGracefully(long p0, long p1, TimeUnit p2);
    io.netty.util.concurrent.Future<? extends Object> submit(Runnable p0);
    io.netty.util.concurrent.Future<? extends Object> terminationFuture();
    io.netty.util.concurrent.ScheduledFuture<? extends Object> schedule(Runnable p0, long p1, TimeUnit p2);
    io.netty.util.concurrent.ScheduledFuture<? extends Object> scheduleAtFixedRate(Runnable p0, long p1, long p2, TimeUnit p3);
    io.netty.util.concurrent.ScheduledFuture<? extends Object> scheduleWithFixedDelay(Runnable p0, long p1, long p2, TimeUnit p3);
    void shutdown();
}
