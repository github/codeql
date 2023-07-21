// Generated automatically from org.apache.hc.core5.http.nio.StreamChannel for testing purposes

package org.apache.hc.core5.http.nio;

import java.nio.Buffer;

public interface StreamChannel<T extends Buffer>
{
    int write(T p0);
    void endStream();
}
