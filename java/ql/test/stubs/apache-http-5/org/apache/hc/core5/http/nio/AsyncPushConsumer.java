// Generated automatically from org.apache.hc.core5.http.nio.AsyncPushConsumer for testing purposes

package org.apache.hc.core5.http.nio;

import org.apache.hc.core5.http.EntityDetails;
import org.apache.hc.core5.http.HttpRequest;
import org.apache.hc.core5.http.HttpResponse;
import org.apache.hc.core5.http.nio.AsyncDataConsumer;
import org.apache.hc.core5.http.protocol.HttpContext;

public interface AsyncPushConsumer extends AsyncDataConsumer
{
    void consumePromise(HttpRequest p0, HttpResponse p1, EntityDetails p2, HttpContext p3);
    void failed(Exception p0);
}
