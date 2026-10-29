// Generated automatically from org.apache.http.HttpHost for testing purposes

package org.apache.http;

import java.io.Serializable;
import java.net.InetAddress;

public class HttpHost implements Cloneable, Serializable
{
    protected HttpHost() {}
    protected final InetAddress address = null;
    protected final String hostname = null;
    protected final String lcHostname = null;
    protected final String schemeName = null;
    protected final int port = 0;
    public HttpHost(HttpHost p0){}
    public HttpHost(InetAddress p0){}
    public HttpHost(InetAddress p0, String p1, int p2, String p3){}
    public HttpHost(InetAddress p0, int p1){}
    public HttpHost(InetAddress p0, int p1, String p2){}
    public HttpHost(String p0){}
    public HttpHost(String p0, int p1){}
    public HttpHost(String p0, int p1, String p2){}
    public InetAddress getAddress(){ return null; }
    public Object clone(){ return null; }
    public String getHostName(){ return null; }
    public String getSchemeName(){ return null; }
    public String toHostString(){ return null; }
    public String toString(){ return null; }
    public String toURI(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int getPort(){ return 0; }
    public int hashCode(){ return 0; }
    public static HttpHost create(String p0){ return null; }
    public static String DEFAULT_SCHEME_NAME = null;
}
