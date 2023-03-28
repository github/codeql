// Generated automatically from org.apache.http.conn.routing.RouteInfo for testing purposes

package org.apache.http.conn.routing;

import java.net.InetAddress;
import org.apache.http.HttpHost;

public interface RouteInfo
{
    HttpHost getHopTarget(int p0);
    HttpHost getProxyHost();
    HttpHost getTargetHost();
    InetAddress getLocalAddress();
    RouteInfo.LayerType getLayerType();
    RouteInfo.TunnelType getTunnelType();
    boolean isLayered();
    boolean isSecure();
    boolean isTunnelled();
    int getHopCount();
    static public enum LayerType
    {
        LAYERED, PLAIN;
        private LayerType() {}
    }
    static public enum TunnelType
    {
        PLAIN, TUNNELLED;
        private TunnelType() {}
    }
}
