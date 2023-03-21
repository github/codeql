// Generated automatically from org.apache.http.conn.HttpRoutedConnection for testing purposes

package org.apache.http.conn;

import javax.net.ssl.SSLSession;
import org.apache.http.HttpInetConnection;
import org.apache.http.conn.routing.HttpRoute;

public interface HttpRoutedConnection extends HttpInetConnection
{
    HttpRoute getRoute();
    SSLSession getSSLSession();
    boolean isSecure();
}
