// Generated automatically from org.apache.hc.core5.http.message.BasicHttpRequest for testing purposes

package org.apache.hc.core5.http.message;

import java.net.URI;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.HttpRequest;
import org.apache.hc.core5.http.Method;
import org.apache.hc.core5.http.ProtocolVersion;
import org.apache.hc.core5.http.message.HeaderGroup;
import org.apache.hc.core5.net.URIAuthority;

public class BasicHttpRequest extends HeaderGroup implements HttpRequest
{
    protected BasicHttpRequest() {}
    public BasicHttpRequest(Method p0, HttpHost p1, String p2){}
    public BasicHttpRequest(Method p0, String p1){}
    public BasicHttpRequest(Method p0, URI p1){}
    public BasicHttpRequest(String p0, HttpHost p1, String p2){}
    public BasicHttpRequest(String p0, String p1){}
    public BasicHttpRequest(String p0, String p1, URIAuthority p2, String p3){}
    public BasicHttpRequest(String p0, URI p1){}
    public ProtocolVersion getVersion(){ return null; }
    public String getMethod(){ return null; }
    public String getPath(){ return null; }
    public String getRequestUri(){ return null; }
    public String getScheme(){ return null; }
    public String toString(){ return null; }
    public URI getUri(){ return null; }
    public URIAuthority getAuthority(){ return null; }
    public void addHeader(String p0, Object p1){}
    public void setAbsoluteRequestUri(boolean p0){}
    public void setAuthority(URIAuthority p0){}
    public void setHeader(String p0, Object p1){}
    public void setPath(String p0){}
    public void setScheme(String p0){}
    public void setUri(URI p0){}
    public void setVersion(ProtocolVersion p0){}
}
