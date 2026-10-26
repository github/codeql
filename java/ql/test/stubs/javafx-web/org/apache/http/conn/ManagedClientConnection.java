// Generated automatically from org.apache.http.conn.ManagedClientConnection for testing purposes

package org.apache.http.conn;

import java.util.concurrent.TimeUnit;
import javax.net.ssl.SSLSession;
import org.apache.http.HttpHost;
import org.apache.http.conn.ConnectionReleaseTrigger;
import org.apache.http.conn.HttpRoutedConnection;
import org.apache.http.conn.ManagedHttpClientConnection;
import org.apache.http.conn.routing.HttpRoute;
import org.apache.http.params.HttpParams;
import org.apache.http.protocol.HttpContext;

public interface ManagedClientConnection extends ConnectionReleaseTrigger, HttpRoutedConnection, ManagedHttpClientConnection
{
    HttpRoute getRoute();
    Object getState();
    SSLSession getSSLSession();
    boolean isMarkedReusable();
    boolean isSecure();
    void layerProtocol(HttpContext p0, HttpParams p1);
    void markReusable();
    void open(HttpRoute p0, HttpContext p1, HttpParams p2);
    void setIdleDuration(long p0, TimeUnit p1);
    void setState(Object p0);
    void tunnelProxy(HttpHost p0, boolean p1, HttpParams p2);
    void tunnelTarget(boolean p0, HttpParams p1);
    void unmarkReusable();
}
