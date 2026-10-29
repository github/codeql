// Generated automatically from okhttp3.internal.connection.RealConnection for testing purposes

package okhttp3.internal.connection;

import java.io.IOException;
import java.lang.ref.Reference;
import java.net.Socket;
import java.util.List;
import okhttp3.Address;
import okhttp3.Call;
import okhttp3.Connection;
import okhttp3.EventListener;
import okhttp3.Handshake;
import okhttp3.OkHttpClient;
import okhttp3.Protocol;
import okhttp3.Route;
import okhttp3.internal.connection.Exchange;
import okhttp3.internal.connection.RealCall;
import okhttp3.internal.connection.RealConnectionPool;
import okhttp3.internal.http.ExchangeCodec;
import okhttp3.internal.http.RealInterceptorChain;
import okhttp3.internal.http2.Http2Connection;
import okhttp3.internal.http2.Http2Stream;
import okhttp3.internal.http2.Settings;
import okhttp3.internal.ws.RealWebSocket;

public class RealConnection extends Http2Connection.Listener implements Connection
{
    protected RealConnection() {}
    public Handshake handshake(){ return null; }
    public Protocol protocol(){ return null; }
    public RealConnection(RealConnectionPool p0, Route p1){}
    public Route route(){ return null; }
    public Socket socket(){ return null; }
    public String toString(){ return null; }
    public final ExchangeCodec newCodec$okhttp(OkHttpClient p0, RealInterceptorChain p1){ return null; }
    public final List<Reference<RealCall>> getCalls(){ return null; }
    public final RealConnectionPool getConnectionPool(){ return null; }
    public final RealWebSocket.Streams newWebSocketStreams$okhttp(Exchange p0){ return null; }
    public final boolean getNoNewExchanges(){ return false; }
    public final boolean isEligible$okhttp(Address p0, List<Route> p1){ return false; }
    public final boolean isHealthy(boolean p0){ return false; }
    public final boolean isMultiplexed$okhttp(){ return false; }
    public final int getRouteFailureCount$okhttp(){ return 0; }
    public final long getIdleAtNs$okhttp(){ return 0; }
    public final void cancel(){}
    public final void connect(int p0, int p1, int p2, int p3, boolean p4, Call p5, EventListener p6){}
    public final void connectFailed$okhttp(OkHttpClient p0, Route p1, IOException p2){}
    public final void incrementSuccessCount$okhttp(){}
    public final void noCoalescedConnections$okhttp(){}
    public final void noNewExchanges$okhttp(){}
    public final void setIdleAtNs$okhttp(long p0){}
    public final void setNoNewExchanges(boolean p0){}
    public final void setRouteFailureCount$okhttp(int p0){}
    public final void trackFailure$okhttp(RealCall p0, IOException p1){}
    public static RealConnection.Companion Companion = null;
    public static long IDLE_CONNECTION_HEALTHY_NS = 0;
    public void onSettings(Http2Connection p0, Settings p1){}
    public void onStream(Http2Stream p0){}
    static public class Companion
    {
        protected Companion() {}
        public final RealConnection newTestConnection(RealConnectionPool p0, Route p1, Socket p2, long p3){ return null; }
    }
}
