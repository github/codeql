// Generated automatically from org.apache.hc.core5.http.nio.AsyncDataConsumer for testing purposes

package org.apache.hc.core5.http.nio;

import java.nio.ByteBuffer;
import java.util.List;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.nio.CapacityChannel;
import org.apache.hc.core5.http.nio.ResourceHolder;

public interface AsyncDataConsumer extends ResourceHolder
{
    void consume(ByteBuffer p0);
    void streamEnd(List<? extends Header> p0);
    void updateCapacity(CapacityChannel p0);
}
