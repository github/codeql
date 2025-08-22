// Generated automatically from org.apache.hc.core5.http.nio.AsyncClientEndpoint for testing purposes

package org.apache.hc.core5.http.nio;

import java.util.concurrent.Future;
import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.http.nio.AsyncClientExchangeHandler;
import org.apache.hc.core5.http.nio.AsyncPushConsumer;
import org.apache.hc.core5.http.nio.AsyncRequestProducer;
import org.apache.hc.core5.http.nio.AsyncResponseConsumer;
import org.apache.hc.core5.http.nio.HandlerFactory;
import org.apache.hc.core5.http.nio.ResourceHolder;
import org.apache.hc.core5.http.protocol.HttpContext;

abstract public class AsyncClientEndpoint
{
    public AsyncClientEndpoint(){}
    public abstract boolean isConnected();
    public abstract void execute(AsyncClientExchangeHandler p0, HandlerFactory<AsyncPushConsumer> p1, HttpContext p2);
    public abstract void releaseAndDiscard();
    public abstract void releaseAndReuse();
    public final <T> java.util.concurrent.Future<T> execute(AsyncRequestProducer p0, org.apache.hc.core5.http.nio.AsyncResponseConsumer<T> p1, HandlerFactory<AsyncPushConsumer> p2, HttpContext p3, org.apache.hc.core5.concurrent.FutureCallback<T> p4){ return null; }
    public final <T> java.util.concurrent.Future<T> execute(AsyncRequestProducer p0, org.apache.hc.core5.http.nio.AsyncResponseConsumer<T> p1, HttpContext p2, org.apache.hc.core5.concurrent.FutureCallback<T> p3){ return null; }
    public final <T> java.util.concurrent.Future<T> execute(AsyncRequestProducer p0, org.apache.hc.core5.http.nio.AsyncResponseConsumer<T> p1, org.apache.hc.core5.concurrent.FutureCallback<T> p2){ return null; }
    public void execute(AsyncClientExchangeHandler p0, HttpContext p1){}
}
