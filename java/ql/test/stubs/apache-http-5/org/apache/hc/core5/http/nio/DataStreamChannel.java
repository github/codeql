// Generated automatically from org.apache.hc.core5.http.nio.DataStreamChannel for testing purposes

package org.apache.hc.core5.http.nio;

import java.nio.Buffer;
import java.nio.ByteBuffer;
import java.util.List;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.nio.StreamChannel;

public interface DataStreamChannel extends StreamChannel<ByteBuffer>
{
    int write(ByteBuffer p0);
    void endStream(List<? extends Header> p0);
    void requestOutput();
}
