// Generated automatically from org.apache.http.HttpInetConnection for testing purposes

package org.apache.http;

import java.net.InetAddress;
import org.apache.http.HttpConnection;

public interface HttpInetConnection extends HttpConnection
{
    InetAddress getLocalAddress();
    InetAddress getRemoteAddress();
    int getLocalPort();
    int getRemotePort();
}
