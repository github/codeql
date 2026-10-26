// Generated automatically from io.netty.util.concurrent.GenericFutureListener for testing purposes

package io.netty.util.concurrent;

import java.util.EventListener;

public interface GenericFutureListener<F extends io.netty.util.concurrent.Future<? extends Object>> extends EventListener
{
    void operationComplete(F p0);
}
