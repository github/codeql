// Generated automatically from okhttp3.internal.connection.ExchangeFinder for testing purposes

package okhttp3.internal.connection;

import java.io.IOException;
import okhttp3.Address;
import okhttp3.EventListener;
import okhttp3.HttpUrl;
import okhttp3.OkHttpClient;
import okhttp3.internal.connection.RealCall;
import okhttp3.internal.connection.RealConnectionPool;
import okhttp3.internal.http.ExchangeCodec;
import okhttp3.internal.http.RealInterceptorChain;

public class ExchangeFinder
{
    protected ExchangeFinder() {}
    public ExchangeFinder(RealConnectionPool p0, Address p1, RealCall p2, EventListener p3){}
    public final Address getAddress$okhttp(){ return null; }
    public final ExchangeCodec find(OkHttpClient p0, RealInterceptorChain p1){ return null; }
    public final boolean retryAfterFailure(){ return false; }
    public final boolean sameHostAndPort(HttpUrl p0){ return false; }
    public final void trackFailure(IOException p0){}
}
