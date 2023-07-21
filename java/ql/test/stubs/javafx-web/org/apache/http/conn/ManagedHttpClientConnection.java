// Generated automatically from org.apache.http.conn.ManagedHttpClientConnection for testing purposes

package org.apache.http.conn;

import java.net.Socket;
import javax.net.ssl.SSLSession;
import org.apache.http.HttpClientConnection;
import org.apache.http.HttpInetConnection;

public interface ManagedHttpClientConnection extends HttpClientConnection, HttpInetConnection
{
    SSLSession getSSLSession();
    Socket getSocket();
    String getId();
    void bind(Socket p0);
}
