// Generated automatically from okhttp3.internal.connection.RealCall for testing purposes

package okhttp3.internal.connection;

import java.io.IOException;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.atomic.AtomicInteger;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.EventListener;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.internal.connection.Exchange;
import okhttp3.internal.connection.RealConnection;
import okhttp3.internal.http.RealInterceptorChain;
import okio.AsyncTimeout;

public class RealCall implements Call
{
    protected RealCall() {}
    public AsyncTimeout timeout(){ return null; }
    public RealCall clone(){ return null; }
    public RealCall(OkHttpClient p0, Request p1, boolean p2){}
    public Request request(){ return null; }
    public Response execute(){ return null; }
    public boolean isCanceled(){ return false; }
    public boolean isExecuted(){ return false; }
    public class AsyncCall implements Runnable
    {
        protected AsyncCall() {}
        public AsyncCall(Callback p0){}
        public final AtomicInteger getCallsPerHost(){ return null; }
        public final RealCall getCall(){ return null; }
        public final Request getRequest(){ return null; }
        public final String getHost(){ return null; }
        public final void executeOn(ExecutorService p0){}
        public final void reuseCallsPerHostFrom(RealCall.AsyncCall p0){}
        public void run(){}
    }
    public final <E extends IOException> E messageDone$okhttp(Exchange p0, boolean p1, boolean p2, E p3){ return null; }
    public final EventListener getEventListener$okhttp(){ return null; }
    public final Exchange getInterceptorScopedExchange$okhttp(){ return null; }
    public final Exchange initExchange$okhttp(RealInterceptorChain p0){ return null; }
    public final IOException noMoreExchanges$okhttp(IOException p0){ return null; }
    public final OkHttpClient getClient(){ return null; }
    public final RealConnection getConnection(){ return null; }
    public final RealConnection getConnectionToCancel(){ return null; }
    public final Request getOriginalRequest(){ return null; }
    public final Response getResponseWithInterceptorChain$okhttp(){ return null; }
    public final Socket releaseConnectionNoEvents$okhttp(){ return null; }
    public final String redactedUrl$okhttp(){ return null; }
    public final boolean getForWebSocket(){ return false; }
    public final boolean retryAfterFailure(){ return false; }
    public final void acquireConnectionNoEvents(RealConnection p0){}
    public final void enterNetworkInterceptorExchange(Request p0, boolean p1){}
    public final void exitNetworkInterceptorExchange$okhttp(boolean p0){}
    public final void setConnectionToCancel(RealConnection p0){}
    public final void timeoutEarlyExit(){}
    public void cancel(){}
    public void enqueue(Callback p0){}
}
