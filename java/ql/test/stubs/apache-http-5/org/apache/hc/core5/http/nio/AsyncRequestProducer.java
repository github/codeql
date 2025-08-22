// Generated automatically from org.apache.hc.core5.http.nio.AsyncRequestProducer for testing purposes

package org.apache.hc.core5.http.nio;

import org.apache.hc.core5.http.nio.AsyncDataProducer;
import org.apache.hc.core5.http.nio.RequestChannel;
import org.apache.hc.core5.http.protocol.HttpContext;

public interface AsyncRequestProducer extends AsyncDataProducer
{
    boolean isRepeatable();
    void failed(Exception p0);
    void sendRequest(RequestChannel p0, HttpContext p1);
}
