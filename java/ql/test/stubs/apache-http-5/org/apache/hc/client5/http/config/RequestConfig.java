// Generated automatically from org.apache.hc.client5.http.config.RequestConfig for testing purposes

package org.apache.hc.client5.http.config;

import java.util.Collection;
import java.util.concurrent.TimeUnit;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.util.TimeValue;
import org.apache.hc.core5.util.Timeout;

public class RequestConfig implements Cloneable
{
    protected RequestConfig clone(){ return null; }
    protected RequestConfig(){}
    public Collection<String> getProxyPreferredAuthSchemes(){ return null; }
    public Collection<String> getTargetPreferredAuthSchemes(){ return null; }
    public HttpHost getProxy(){ return null; }
    public String getCookieSpec(){ return null; }
    public String toString(){ return null; }
    public TimeValue getConnectionKeepAlive(){ return null; }
    public Timeout getConnectTimeout(){ return null; }
    public Timeout getConnectionRequestTimeout(){ return null; }
    public Timeout getResponseTimeout(){ return null; }
    public boolean isAuthenticationEnabled(){ return false; }
    public boolean isCircularRedirectsAllowed(){ return false; }
    public boolean isContentCompressionEnabled(){ return false; }
    public boolean isExpectContinueEnabled(){ return false; }
    public boolean isHardCancellationEnabled(){ return false; }
    public boolean isRedirectsEnabled(){ return false; }
    public int getMaxRedirects(){ return 0; }
    public static RequestConfig DEFAULT = null;
    public static RequestConfig.Builder copy(RequestConfig p0){ return null; }
    public static RequestConfig.Builder custom(){ return null; }
    static public class Builder
    {
        public RequestConfig build(){ return null; }
        public RequestConfig.Builder setAuthenticationEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setCircularRedirectsAllowed(boolean p0){ return null; }
        public RequestConfig.Builder setConnectTimeout(Timeout p0){ return null; }
        public RequestConfig.Builder setConnectTimeout(long p0, TimeUnit p1){ return null; }
        public RequestConfig.Builder setConnectionKeepAlive(TimeValue p0){ return null; }
        public RequestConfig.Builder setConnectionRequestTimeout(Timeout p0){ return null; }
        public RequestConfig.Builder setConnectionRequestTimeout(long p0, TimeUnit p1){ return null; }
        public RequestConfig.Builder setContentCompressionEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setCookieSpec(String p0){ return null; }
        public RequestConfig.Builder setDefaultKeepAlive(long p0, TimeUnit p1){ return null; }
        public RequestConfig.Builder setExpectContinueEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setHardCancellationEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setMaxRedirects(int p0){ return null; }
        public RequestConfig.Builder setProxy(HttpHost p0){ return null; }
        public RequestConfig.Builder setProxyPreferredAuthSchemes(Collection<String> p0){ return null; }
        public RequestConfig.Builder setRedirectsEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setResponseTimeout(Timeout p0){ return null; }
        public RequestConfig.Builder setResponseTimeout(long p0, TimeUnit p1){ return null; }
        public RequestConfig.Builder setTargetPreferredAuthSchemes(Collection<String> p0){ return null; }
    }
}
