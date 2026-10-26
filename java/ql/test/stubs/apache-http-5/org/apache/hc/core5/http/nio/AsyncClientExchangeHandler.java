// Generated automatically from org.apache.hc.core5.http.nio.AsyncClientExchangeHandler for testing purposes

package org.apache.hc.core5.http.nio;

import org.apache.hc.core5.http.EntityDetails;
import org.apache.hc.core5.http.HttpResponse;
import org.apache.hc.core5.http.nio.AsyncDataExchangeHandler;
import org.apache.hc.core5.http.nio.RequestChannel;
import org.apache.hc.core5.http.protocol.HttpContext;

public interface AsyncClientExchangeHandler extends AsyncDataExchangeHandler
{
    void cancel();
    void consumeInformation(HttpResponse p0, HttpContext p1);
    void consumeResponse(HttpResponse p0, EntityDetails p1, HttpContext p2);
    void produceRequest(RequestChannel p0, HttpContext p1);
}
