// Generated automatically from org.apache.http.client.config.RequestConfig for testing purposes

package org.apache.http.client.config;

import java.net.InetAddress;
import java.util.Collection;
import org.apache.http.HttpHost;

public class RequestConfig implements Cloneable
{
    protected RequestConfig clone(){ return null; }
    protected RequestConfig(){}
    public Collection<String> getProxyPreferredAuthSchemes(){ return null; }
    public Collection<String> getTargetPreferredAuthSchemes(){ return null; }
    public HttpHost getProxy(){ return null; }
    public InetAddress getLocalAddress(){ return null; }
    public String getCookieSpec(){ return null; }
    public String toString(){ return null; }
    public boolean isAuthenticationEnabled(){ return false; }
    public boolean isCircularRedirectsAllowed(){ return false; }
    public boolean isContentCompressionEnabled(){ return false; }
    public boolean isDecompressionEnabled(){ return false; }
    public boolean isExpectContinueEnabled(){ return false; }
    public boolean isNormalizeUri(){ return false; }
    public boolean isRedirectsEnabled(){ return false; }
    public boolean isRelativeRedirectsAllowed(){ return false; }
    public boolean isStaleConnectionCheckEnabled(){ return false; }
    public int getConnectTimeout(){ return 0; }
    public int getConnectionRequestTimeout(){ return 0; }
    public int getMaxRedirects(){ return 0; }
    public int getSocketTimeout(){ return 0; }
    public static RequestConfig DEFAULT = null;
    public static RequestConfig.Builder copy(RequestConfig p0){ return null; }
    public static RequestConfig.Builder custom(){ return null; }
    static public class Builder
    {
        public RequestConfig build(){ return null; }
        public RequestConfig.Builder setAuthenticationEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setCircularRedirectsAllowed(boolean p0){ return null; }
        public RequestConfig.Builder setConnectTimeout(int p0){ return null; }
        public RequestConfig.Builder setConnectionRequestTimeout(int p0){ return null; }
        public RequestConfig.Builder setContentCompressionEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setCookieSpec(String p0){ return null; }
        public RequestConfig.Builder setDecompressionEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setExpectContinueEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setLocalAddress(InetAddress p0){ return null; }
        public RequestConfig.Builder setMaxRedirects(int p0){ return null; }
        public RequestConfig.Builder setNormalizeUri(boolean p0){ return null; }
        public RequestConfig.Builder setProxy(HttpHost p0){ return null; }
        public RequestConfig.Builder setProxyPreferredAuthSchemes(Collection<String> p0){ return null; }
        public RequestConfig.Builder setRedirectsEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setRelativeRedirectsAllowed(boolean p0){ return null; }
        public RequestConfig.Builder setSocketTimeout(int p0){ return null; }
        public RequestConfig.Builder setStaleConnectionCheckEnabled(boolean p0){ return null; }
        public RequestConfig.Builder setTargetPreferredAuthSchemes(Collection<String> p0){ return null; }
    }
}
