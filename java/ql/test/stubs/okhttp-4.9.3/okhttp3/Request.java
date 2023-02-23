// Generated automatically from okhttp3.Request for testing purposes

package okhttp3;

import java.net.URL;
import java.util.List;
import java.util.Map;
import okhttp3.CacheControl;
import okhttp3.Headers;
import okhttp3.HttpUrl;
import okhttp3.RequestBody;

public class Request
{
    protected Request() {}
    public Request(HttpUrl p0, String p1, Headers p2, RequestBody p3, Map<Class<? extends Object>, ? extends Object> p4){}
    public String toString(){ return null; }
    public final <T> T tag(Class<? extends T> p0){ return null; }
    public final CacheControl cacheControl(){ return null; }
    public final Headers headers(){ return null; }
    public final HttpUrl url(){ return null; }
    public final List<String> headers(String p0){ return null; }
    public final Map<Class<? extends Object>, Object> getTags$okhttp(){ return null; }
    public final Object tag(){ return null; }
    public final Request.Builder newBuilder(){ return null; }
    public final RequestBody body(){ return null; }
    public final String header(String p0){ return null; }
    public final String method(){ return null; }
    public final boolean isHttps(){ return false; }
    static public class Builder
    {
        public <T> Request.Builder tag(Class<? super T> p0, T p1){ return null; }
        public Builder(){}
        public Builder(Request p0){}
        public Request build(){ return null; }
        public Request.Builder addHeader(String p0, String p1){ return null; }
        public Request.Builder cacheControl(CacheControl p0){ return null; }
        public Request.Builder delete(RequestBody p0){ return null; }
        public Request.Builder get(){ return null; }
        public Request.Builder head(){ return null; }
        public Request.Builder header(String p0, String p1){ return null; }
        public Request.Builder headers(Headers p0){ return null; }
        public Request.Builder method(String p0, RequestBody p1){ return null; }
        public Request.Builder patch(RequestBody p0){ return null; }
        public Request.Builder post(RequestBody p0){ return null; }
        public Request.Builder put(RequestBody p0){ return null; }
        public Request.Builder removeHeader(String p0){ return null; }
        public Request.Builder tag(Object p0){ return null; }
        public Request.Builder url(HttpUrl p0){ return null; }
        public Request.Builder url(String p0){ return null; }
        public Request.Builder url(URL p0){ return null; }
        public final Headers.Builder getHeaders$okhttp(){ return null; }
        public final HttpUrl getUrl$okhttp(){ return null; }
        public final Map<Class<? extends Object>, Object> getTags$okhttp(){ return null; }
        public final Request.Builder delete(){ return null; }
        public final RequestBody getBody$okhttp(){ return null; }
        public final String getMethod$okhttp(){ return null; }
        public final void setBody$okhttp(RequestBody p0){}
        public final void setHeaders$okhttp(Headers.Builder p0){}
        public final void setMethod$okhttp(String p0){}
        public final void setTags$okhttp(Map<Class<? extends Object>, Object> p0){}
        public final void setUrl$okhttp(HttpUrl p0){}
    }
}
