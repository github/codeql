// Generated automatically from org.apache.http.conn.routing.HttpRoute for testing purposes

package org.apache.http.conn.routing;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import org.apache.http.HttpHost;
import org.apache.http.conn.routing.RouteInfo;

public class HttpRoute implements Cloneable, RouteInfo
{
    protected HttpRoute() {}
    public HttpRoute(HttpHost p0){}
    public HttpRoute(HttpHost p0, HttpHost p1){}
    public HttpRoute(HttpHost p0, InetAddress p1, HttpHost p2, boolean p3){}
    public HttpRoute(HttpHost p0, InetAddress p1, HttpHost p2, boolean p3, RouteInfo.TunnelType p4, RouteInfo.LayerType p5){}
    public HttpRoute(HttpHost p0, InetAddress p1, HttpHost[] p2, boolean p3, RouteInfo.TunnelType p4, RouteInfo.LayerType p5){}
    public HttpRoute(HttpHost p0, InetAddress p1, boolean p2){}
    public Object clone(){ return null; }
    public final HttpHost getHopTarget(int p0){ return null; }
    public final HttpHost getProxyHost(){ return null; }
    public final HttpHost getTargetHost(){ return null; }
    public final InetAddress getLocalAddress(){ return null; }
    public final InetSocketAddress getLocalSocketAddress(){ return null; }
    public final RouteInfo.LayerType getLayerType(){ return null; }
    public final RouteInfo.TunnelType getTunnelType(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean isLayered(){ return false; }
    public final boolean isSecure(){ return false; }
    public final boolean isTunnelled(){ return false; }
    public final int getHopCount(){ return 0; }
    public final int hashCode(){ return 0; }
}
