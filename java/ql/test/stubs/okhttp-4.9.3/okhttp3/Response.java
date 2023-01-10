// Generated automatically from okhttp3.Response for testing purposes

package okhttp3;

import java.io.Closeable;
import java.util.List;
import okhttp3.CacheControl;
import okhttp3.Challenge;
import okhttp3.Handshake;
import okhttp3.Headers;
import okhttp3.Protocol;
import okhttp3.Request;
import okhttp3.ResponseBody;
import okhttp3.internal.connection.Exchange;

public class Response implements Closeable
{
    protected Response() {}
    public Response(Request p0, Protocol p1, String p2, int p3, Handshake p4, Headers p5, ResponseBody p6, Response p7, Response p8, Response p9, long p10, long p11, Exchange p12){}
    public String toString(){ return null; }
    public final CacheControl cacheControl(){ return null; }
    public final Exchange exchange(){ return null; }
    public final Handshake handshake(){ return null; }
    public final Headers headers(){ return null; }
    public final Headers trailers(){ return null; }
    public final List<Challenge> challenges(){ return null; }
    public final List<String> headers(String p0){ return null; }
    public final Protocol protocol(){ return null; }
    public final Request request(){ return null; }
    public final Response cacheResponse(){ return null; }
    public final Response networkResponse(){ return null; }
    public final Response priorResponse(){ return null; }
    public final Response.Builder newBuilder(){ return null; }
    public final ResponseBody body(){ return null; }
    public final ResponseBody peekBody(long p0){ return null; }
    public final String header(String p0){ return null; }
    public final String header(String p0, String p1){ return null; }
    public final String message(){ return null; }
    public final boolean isRedirect(){ return false; }
    public final boolean isSuccessful(){ return false; }
    public final int code(){ return 0; }
    public final long receivedResponseAtMillis(){ return 0; }
    public final long sentRequestAtMillis(){ return 0; }
    public void close(){}
    static public class Builder
    {
        public Builder(){}
        public Builder(Response p0){}
        public Response build(){ return null; }
        public Response.Builder addHeader(String p0, String p1){ return null; }
        public Response.Builder body(ResponseBody p0){ return null; }
        public Response.Builder cacheResponse(Response p0){ return null; }
        public Response.Builder code(int p0){ return null; }
        public Response.Builder handshake(Handshake p0){ return null; }
        public Response.Builder header(String p0, String p1){ return null; }
        public Response.Builder headers(Headers p0){ return null; }
        public Response.Builder message(String p0){ return null; }
        public Response.Builder networkResponse(Response p0){ return null; }
        public Response.Builder priorResponse(Response p0){ return null; }
        public Response.Builder protocol(Protocol p0){ return null; }
        public Response.Builder receivedResponseAtMillis(long p0){ return null; }
        public Response.Builder removeHeader(String p0){ return null; }
        public Response.Builder request(Request p0){ return null; }
        public Response.Builder sentRequestAtMillis(long p0){ return null; }
        public final Exchange getExchange$okhttp(){ return null; }
        public final Handshake getHandshake$okhttp(){ return null; }
        public final Headers.Builder getHeaders$okhttp(){ return null; }
        public final Protocol getProtocol$okhttp(){ return null; }
        public final Request getRequest$okhttp(){ return null; }
        public final Response getCacheResponse$okhttp(){ return null; }
        public final Response getNetworkResponse$okhttp(){ return null; }
        public final Response getPriorResponse$okhttp(){ return null; }
        public final ResponseBody getBody$okhttp(){ return null; }
        public final String getMessage$okhttp(){ return null; }
        public final int getCode$okhttp(){ return 0; }
        public final long getReceivedResponseAtMillis$okhttp(){ return 0; }
        public final long getSentRequestAtMillis$okhttp(){ return 0; }
        public final void initExchange$okhttp(Exchange p0){}
        public final void setBody$okhttp(ResponseBody p0){}
        public final void setCacheResponse$okhttp(Response p0){}
        public final void setCode$okhttp(int p0){}
        public final void setExchange$okhttp(Exchange p0){}
        public final void setHandshake$okhttp(Handshake p0){}
        public final void setHeaders$okhttp(Headers.Builder p0){}
        public final void setMessage$okhttp(String p0){}
        public final void setNetworkResponse$okhttp(Response p0){}
        public final void setPriorResponse$okhttp(Response p0){}
        public final void setProtocol$okhttp(Protocol p0){}
        public final void setReceivedResponseAtMillis$okhttp(long p0){}
        public final void setRequest$okhttp(Request p0){}
        public final void setSentRequestAtMillis$okhttp(long p0){}
    }
}
