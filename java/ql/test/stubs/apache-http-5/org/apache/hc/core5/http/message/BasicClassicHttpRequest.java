// Generated automatically from org.apache.hc.core5.http.message.BasicClassicHttpRequest for testing purposes

package org.apache.hc.core5.http.message;

import java.net.URI;
import org.apache.hc.core5.http.ClassicHttpRequest;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.Method;
import org.apache.hc.core5.http.message.BasicHttpRequest;
import org.apache.hc.core5.net.URIAuthority;

public class BasicClassicHttpRequest extends BasicHttpRequest implements ClassicHttpRequest
{
    protected BasicClassicHttpRequest() {}
    public BasicClassicHttpRequest(Method p0, HttpHost p1, String p2){}
    public BasicClassicHttpRequest(Method p0, String p1){}
    public BasicClassicHttpRequest(Method p0, URI p1){}
    public BasicClassicHttpRequest(String p0, HttpHost p1, String p2){}
    public BasicClassicHttpRequest(String p0, String p1){}
    public BasicClassicHttpRequest(String p0, String p1, URIAuthority p2, String p3){}
    public BasicClassicHttpRequest(String p0, URI p1){}
    public HttpEntity getEntity(){ return null; }
    public void setEntity(HttpEntity p0){}
}
