// Generated automatically from org.apache.hc.client5.http.async.methods.SimpleHttpRequest for testing purposes

package org.apache.hc.client5.http.async.methods;

import java.net.URI;
import org.apache.hc.client5.http.async.methods.ConfigurableHttpRequest;
import org.apache.hc.client5.http.async.methods.SimpleBody;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.HttpRequest;
import org.apache.hc.core5.http.Method;
import org.apache.hc.core5.net.URIAuthority;

public class SimpleHttpRequest extends ConfigurableHttpRequest
{
    protected SimpleHttpRequest() {}
    public ContentType getContentType(){ return null; }
    public SimpleBody getBody(){ return null; }
    public SimpleHttpRequest(Method p0, HttpHost p1, String p2){}
    public SimpleHttpRequest(Method p0, URI p1){}
    public SimpleHttpRequest(String p0, HttpHost p1, String p2){}
    public SimpleHttpRequest(String p0, String p1){}
    public SimpleHttpRequest(String p0, String p1, URIAuthority p2, String p3){}
    public SimpleHttpRequest(String p0, URI p1){}
    public String getBodyText(){ return null; }
    public byte[] getBodyBytes(){ return null; }
    public static SimpleHttpRequest copy(HttpRequest p0){ return null; }
    public static SimpleHttpRequest create(Method p0, HttpHost p1, String p2){ return null; }
    public static SimpleHttpRequest create(Method p0, URI p1){ return null; }
    public static SimpleHttpRequest create(String p0, String p1){ return null; }
    public static SimpleHttpRequest create(String p0, String p1, URIAuthority p2, String p3){ return null; }
    public static SimpleHttpRequest create(String p0, URI p1){ return null; }
    public void setBody(SimpleBody p0){}
    public void setBody(String p0, ContentType p1){}
    public void setBody(byte[] p0, ContentType p1){}
}
