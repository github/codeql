// Generated automatically from org.apache.http.conn.ClientConnectionRequest for testing purposes

package org.apache.http.conn;

import java.util.concurrent.TimeUnit;
import org.apache.http.conn.ManagedClientConnection;

public interface ClientConnectionRequest
{
    ManagedClientConnection getConnection(long p0, TimeUnit p1);
    void abortRequest();
}
