// Generated automatically from org.apache.hc.core5.http.support.AbstractRequestBuilder for testing purposes

package org.apache.hc.core5.http.support;

import java.net.URI;
import java.nio.charset.Charset;
import java.util.List;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.HttpRequest;
import org.apache.hc.core5.http.Method;
import org.apache.hc.core5.http.NameValuePair;
import org.apache.hc.core5.http.ProtocolVersion;
import org.apache.hc.core5.http.support.AbstractMessageBuilder;
import org.apache.hc.core5.net.URIAuthority;

abstract public class AbstractRequestBuilder<T> extends AbstractMessageBuilder<T>
{
    protected AbstractRequestBuilder() {}
    protected AbstractRequestBuilder(Method p0){}
    protected AbstractRequestBuilder(Method p0, String p1){}
    protected AbstractRequestBuilder(Method p0, URI p1){}
    protected AbstractRequestBuilder(String p0){}
    protected AbstractRequestBuilder(String p0, String p1){}
    protected AbstractRequestBuilder(String p0, URI p1){}
    protected void digest(HttpRequest p0){}
    public AbstractRequestBuilder<T> addHeader(Header p0){ return null; }
    public AbstractRequestBuilder<T> addHeader(String p0, String p1){ return null; }
    public AbstractRequestBuilder<T> addParameter(NameValuePair p0){ return null; }
    public AbstractRequestBuilder<T> addParameter(String p0, String p1){ return null; }
    public AbstractRequestBuilder<T> addParameters(NameValuePair... p0){ return null; }
    public AbstractRequestBuilder<T> removeHeader(Header p0){ return null; }
    public AbstractRequestBuilder<T> removeHeaders(String p0){ return null; }
    public AbstractRequestBuilder<T> setAbsoluteRequestUri(boolean p0){ return null; }
    public AbstractRequestBuilder<T> setAuthority(URIAuthority p0){ return null; }
    public AbstractRequestBuilder<T> setCharset(Charset p0){ return null; }
    public AbstractRequestBuilder<T> setHeader(Header p0){ return null; }
    public AbstractRequestBuilder<T> setHeader(String p0, String p1){ return null; }
    public AbstractRequestBuilder<T> setHeaders(Header... p0){ return null; }
    public AbstractRequestBuilder<T> setHttpHost(HttpHost p0){ return null; }
    public AbstractRequestBuilder<T> setPath(String p0){ return null; }
    public AbstractRequestBuilder<T> setScheme(String p0){ return null; }
    public AbstractRequestBuilder<T> setUri(String p0){ return null; }
    public AbstractRequestBuilder<T> setUri(URI p0){ return null; }
    public AbstractRequestBuilder<T> setVersion(ProtocolVersion p0){ return null; }
    public Charset getCharset(){ return null; }
    public List<NameValuePair> getParameters(){ return null; }
    public String getMethod(){ return null; }
    public String getPath(){ return null; }
    public String getScheme(){ return null; }
    public URI getUri(){ return null; }
    public URIAuthority getAuthority(){ return null; }
    public boolean isAbsoluteRequestUri(){ return false; }
}
