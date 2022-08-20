// Generated automatically from com.google.common.util.concurrent.ListenableFuture for testing purposes

package com.google.common.util.concurrent;

import java.util.concurrent.Executor;
import java.util.concurrent.Future;

public interface ListenableFuture<V> extends Future<V>
{
    void addListener(Runnable p0, Executor p1);
}
