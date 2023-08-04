// Generated automatically from org.apache.hc.core5.http.impl.bootstrap.AsyncRequester for testing purposes

package org.apache.hc.core5.http.impl.bootstrap;

import java.net.InetSocketAddress;
import java.util.concurrent.Future;
import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.function.Callback;
import org.apache.hc.core5.function.Decorator;
import org.apache.hc.core5.function.Resolver;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.impl.bootstrap.AbstractConnectionInitiatorBase;
import org.apache.hc.core5.io.CloseMode;
import org.apache.hc.core5.reactor.IOEventHandlerFactory;
import org.apache.hc.core5.reactor.IOReactorConfig;
import org.apache.hc.core5.reactor.IOReactorService;
import org.apache.hc.core5.reactor.IOReactorStatus;
import org.apache.hc.core5.reactor.IOSession;
import org.apache.hc.core5.reactor.IOSessionListener;
import org.apache.hc.core5.util.TimeValue;
import org.apache.hc.core5.util.Timeout;

public class AsyncRequester extends AbstractConnectionInitiatorBase implements IOReactorService
{
    protected AsyncRequester() {}
    public AsyncRequester(IOEventHandlerFactory p0, IOReactorConfig p1, Decorator<IOSession> p2, Callback<Exception> p3, IOSessionListener p4, Callback<IOSession> p5, Resolver<HttpHost, InetSocketAddress> p6){}
    public Future<IOSession> requestSession(HttpHost p0, Timeout p1, Object p2, FutureCallback<IOSession> p3){ return null; }
    public IOReactorStatus getStatus(){ return null; }
    public void awaitShutdown(TimeValue p0){}
    public void close(){}
    public void close(CloseMode p0){}
    public void initiateShutdown(){}
    public void start(){}
}
