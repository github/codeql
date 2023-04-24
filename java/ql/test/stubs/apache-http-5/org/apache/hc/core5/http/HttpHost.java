// Generated automatically from org.apache.hc.core5.http.HttpHost for testing purposes

package org.apache.hc.core5.http;

import java.io.Serializable;
import java.net.InetAddress;
import java.net.URI;
import org.apache.hc.core5.http.URIScheme;
import org.apache.hc.core5.net.NamedEndpoint;
import org.apache.hc.core5.net.URIAuthority;

public class HttpHost implements NamedEndpoint, Serializable
{
    protected HttpHost() {}
    public HttpHost(InetAddress p0){}
    public HttpHost(InetAddress p0, int p1){}
    public HttpHost(String p0){}
    public HttpHost(String p0, InetAddress p1, String p2, int p3){}
    public HttpHost(String p0, InetAddress p1, int p2){}
    public HttpHost(String p0, NamedEndpoint p1){}
    public HttpHost(String p0, String p1){}
    public HttpHost(String p0, String p1, int p2){}
    public HttpHost(String p0, int p1){}
    public HttpHost(URIAuthority p0){}
    public InetAddress getAddress(){ return null; }
    public String getHostName(){ return null; }
    public String getSchemeName(){ return null; }
    public String toHostString(){ return null; }
    public String toString(){ return null; }
    public String toURI(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int getPort(){ return 0; }
    public int hashCode(){ return 0; }
    public static HttpHost create(String p0){ return null; }
    public static HttpHost create(URI p0){ return null; }
    public static URIScheme DEFAULT_SCHEME = null;
}
