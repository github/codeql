// Generated automatically from org.apache.hc.core5.http.impl.bootstrap.HttpAsyncRequester for testing purposes

package org.apache.hc.core5.http.impl.bootstrap;

import java.util.Set;
import java.util.concurrent.Future;
import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.function.Callback;
import org.apache.hc.core5.function.Decorator;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.impl.bootstrap.AsyncRequester;
import org.apache.hc.core5.http.nio.AsyncClientEndpoint;
import org.apache.hc.core5.http.nio.AsyncClientExchangeHandler;
import org.apache.hc.core5.http.nio.AsyncPushConsumer;
import org.apache.hc.core5.http.nio.AsyncRequestProducer;
import org.apache.hc.core5.http.nio.AsyncResponseConsumer;
import org.apache.hc.core5.http.nio.HandlerFactory;
import org.apache.hc.core5.http.nio.ResourceHolder;
import org.apache.hc.core5.http.nio.ssl.TlsStrategy;
import org.apache.hc.core5.http.protocol.HttpContext;
import org.apache.hc.core5.io.ModalCloseable;
import org.apache.hc.core5.net.NamedEndpoint;
import org.apache.hc.core5.pool.ConnPoolControl;
import org.apache.hc.core5.pool.ManagedConnPool;
import org.apache.hc.core5.pool.PoolStats;
import org.apache.hc.core5.reactor.IOEventHandlerFactory;
import org.apache.hc.core5.reactor.IOReactorConfig;
import org.apache.hc.core5.reactor.IOSession;
import org.apache.hc.core5.reactor.IOSessionListener;
import org.apache.hc.core5.reactor.ProtocolIOSession;
import org.apache.hc.core5.util.TimeValue;
import org.apache.hc.core5.util.Timeout;

public class HttpAsyncRequester extends AsyncRequester implements ConnPoolControl<HttpHost>
{
    protected HttpAsyncRequester() {}
    protected Future<AsyncClientEndpoint> doConnect(HttpHost p0, Timeout p1, Object p2, FutureCallback<AsyncClientEndpoint> p3){ return null; }
    protected void doTlsUpgrade(ProtocolIOSession p0, NamedEndpoint p1, FutureCallback<ProtocolIOSession> p2){}
    public Future<AsyncClientEndpoint> connect(HttpHost p0, Timeout p1){ return null; }
    public Future<AsyncClientEndpoint> connect(HttpHost p0, Timeout p1, Object p2, FutureCallback<AsyncClientEndpoint> p3){ return null; }
    public HttpAsyncRequester(IOReactorConfig p0, IOEventHandlerFactory p1, Decorator<IOSession> p2, Callback<Exception> p3, IOSessionListener p4, ManagedConnPool<HttpHost, IOSession> p5){}
    public HttpAsyncRequester(IOReactorConfig p0, IOEventHandlerFactory p1, Decorator<IOSession> p2, Callback<Exception> p3, IOSessionListener p4, ManagedConnPool<HttpHost, IOSession> p5, TlsStrategy p6, Timeout p7){}
    public PoolStats getStats(HttpHost p0){ return null; }
    public PoolStats getTotalStats(){ return null; }
    public Set<HttpHost> getRoutes(){ return null; }
    public final <T> java.util.concurrent.Future<T> execute(AsyncRequestProducer p0, org.apache.hc.core5.http.nio.AsyncResponseConsumer<T> p1, HandlerFactory<AsyncPushConsumer> p2, Timeout p3, HttpContext p4, org.apache.hc.core5.concurrent.FutureCallback<T> p5){ return null; }
    public final <T> java.util.concurrent.Future<T> execute(AsyncRequestProducer p0, org.apache.hc.core5.http.nio.AsyncResponseConsumer<T> p1, Timeout p2, HttpContext p3, org.apache.hc.core5.concurrent.FutureCallback<T> p4){ return null; }
    public final <T> java.util.concurrent.Future<T> execute(AsyncRequestProducer p0, org.apache.hc.core5.http.nio.AsyncResponseConsumer<T> p1, Timeout p2, org.apache.hc.core5.concurrent.FutureCallback<T> p3){ return null; }
    public int getDefaultMaxPerRoute(){ return 0; }
    public int getMaxPerRoute(HttpHost p0){ return 0; }
    public int getMaxTotal(){ return 0; }
    public void closeExpired(){}
    public void closeIdle(TimeValue p0){}
    public void execute(AsyncClientExchangeHandler p0, HandlerFactory<AsyncPushConsumer> p1, Timeout p2, HttpContext p3){}
    public void execute(AsyncClientExchangeHandler p0, Timeout p1, HttpContext p2){}
    public void setDefaultMaxPerRoute(int p0){}
    public void setMaxPerRoute(HttpHost p0, int p1){}
    public void setMaxTotal(int p0){}
}
