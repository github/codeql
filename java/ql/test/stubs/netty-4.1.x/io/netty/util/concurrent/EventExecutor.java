// Generated automatically from io.netty.util.concurrent.EventExecutor for testing purposes

package io.netty.util.concurrent;

import io.netty.util.concurrent.EventExecutorGroup;
import io.netty.util.concurrent.ProgressivePromise;
import io.netty.util.concurrent.Promise;

public interface EventExecutor extends EventExecutorGroup
{
    <V> ProgressivePromise<V> newProgressivePromise();
    <V> io.netty.util.concurrent.Future<V> newFailedFuture(Throwable p0);
    <V> io.netty.util.concurrent.Future<V> newSucceededFuture(V p0);
    <V> io.netty.util.concurrent.Promise<V> newPromise();
    EventExecutor next();
    EventExecutorGroup parent();
    boolean inEventLoop();
    boolean inEventLoop(Thread p0);
}
