// Generated automatically from org.apache.hc.core5.http.nio.AsyncDataProducer for testing purposes

package org.apache.hc.core5.http.nio;

import org.apache.hc.core5.http.nio.DataStreamChannel;
import org.apache.hc.core5.http.nio.ResourceHolder;

public interface AsyncDataProducer extends ResourceHolder
{
    int available();
    void produce(DataStreamChannel p0);
}
