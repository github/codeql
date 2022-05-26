// Generated automatically from okhttp3.internal.connection.Exchange for testing purposes

package okhttp3.internal.connection;

import java.io.IOException;
import okhttp3.EventListener;
import okhttp3.Headers;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import okhttp3.internal.connection.ExchangeFinder;
import okhttp3.internal.connection.RealCall;
import okhttp3.internal.connection.RealConnection;
import okhttp3.internal.http.ExchangeCodec;
import okhttp3.internal.ws.RealWebSocket;
import okio.Sink;

public class Exchange
{
    protected Exchange() {}
    public Exchange(RealCall p0, EventListener p1, ExchangeFinder p2, ExchangeCodec p3){}
    public final <E extends IOException> E bodyComplete(long p0, boolean p1, boolean p2, E p3){ return null; }
    public final EventListener getEventListener$okhttp(){ return null; }
    public final ExchangeFinder getFinder$okhttp(){ return null; }
    public final Headers trailers(){ return null; }
    public final RealCall getCall$okhttp(){ return null; }
    public final RealConnection getConnection$okhttp(){ return null; }
    public final RealWebSocket.Streams newWebSocketStreams(){ return null; }
    public final Response.Builder readResponseHeaders(boolean p0){ return null; }
    public final ResponseBody openResponseBody(Response p0){ return null; }
    public final Sink createRequestBody(Request p0, boolean p1){ return null; }
    public final boolean isCoalescedConnection$okhttp(){ return false; }
    public final boolean isDuplex$okhttp(){ return false; }
    public final void cancel(){}
    public final void detachWithViolence(){}
    public final void finishRequest(){}
    public final void flushRequest(){}
    public final void noNewExchangesOnConnection(){}
    public final void noRequestBody(){}
    public final void responseHeadersEnd(Response p0){}
    public final void responseHeadersStart(){}
    public final void webSocketUpgradeFailed(){}
    public final void writeRequestHeaders(Request p0){}
}
