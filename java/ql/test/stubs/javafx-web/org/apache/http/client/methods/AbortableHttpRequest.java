// Generated automatically from org.apache.http.client.methods.AbortableHttpRequest for testing purposes

package org.apache.http.client.methods;

import org.apache.http.conn.ClientConnectionRequest;
import org.apache.http.conn.ConnectionReleaseTrigger;

public interface AbortableHttpRequest
{
    void abort();
    void setConnectionRequest(ClientConnectionRequest p0);
    void setReleaseTrigger(ConnectionReleaseTrigger p0);
}
