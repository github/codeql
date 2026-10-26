// Generated automatically from org.apache.hc.core5.http.nio.AsyncResponseConsumer for testing purposes

package org.apache.hc.core5.http.nio;

import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.http.EntityDetails;
import org.apache.hc.core5.http.HttpResponse;
import org.apache.hc.core5.http.nio.AsyncDataConsumer;
import org.apache.hc.core5.http.protocol.HttpContext;

public interface AsyncResponseConsumer<T> extends AsyncDataConsumer
{
    void consumeResponse(HttpResponse p0, EntityDetails p1, HttpContext p2, org.apache.hc.core5.concurrent.FutureCallback<T> p3);
    void failed(Exception p0);
    void informationResponse(HttpResponse p0, HttpContext p1);
}
