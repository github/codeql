// Generated automatically from okhttp3.internal.http.RealInterceptorChain for testing purposes

package okhttp3.internal.http;

import java.util.List;
import java.util.concurrent.TimeUnit;
import okhttp3.Call;
import okhttp3.Connection;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.internal.connection.Exchange;
import okhttp3.internal.connection.RealCall;

public class RealInterceptorChain implements Interceptor.Chain
{
    protected RealInterceptorChain() {}
    public Call call(){ return null; }
    public Connection connection(){ return null; }
    public Interceptor.Chain withConnectTimeout(int p0, TimeUnit p1){ return null; }
    public Interceptor.Chain withReadTimeout(int p0, TimeUnit p1){ return null; }
    public Interceptor.Chain withWriteTimeout(int p0, TimeUnit p1){ return null; }
    public RealInterceptorChain(RealCall p0, List<? extends Interceptor> p1, int p2, Exchange p3, Request p4, int p5, int p6, int p7){}
    public Request request(){ return null; }
    public Response proceed(Request p0){ return null; }
    public final Exchange getExchange$okhttp(){ return null; }
    public final RealCall getCall$okhttp(){ return null; }
    public final RealInterceptorChain copy$okhttp(int p0, Exchange p1, Request p2, int p3, int p4, int p5){ return null; }
    public final Request getRequest$okhttp(){ return null; }
    public final int getConnectTimeoutMillis$okhttp(){ return 0; }
    public final int getReadTimeoutMillis$okhttp(){ return 0; }
    public final int getWriteTimeoutMillis$okhttp(){ return 0; }
    public int connectTimeoutMillis(){ return 0; }
    public int readTimeoutMillis(){ return 0; }
    public int writeTimeoutMillis(){ return 0; }
}
