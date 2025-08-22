// Generated automatically from org.apache.hc.core5.reactor.IOEventHandler for testing purposes

package org.apache.hc.core5.reactor;

import java.nio.ByteBuffer;
import org.apache.hc.core5.reactor.IOSession;
import org.apache.hc.core5.util.Timeout;

public interface IOEventHandler
{
    void connected(IOSession p0);
    void disconnected(IOSession p0);
    void exception(IOSession p0, Exception p1);
    void inputReady(IOSession p0, ByteBuffer p1);
    void outputReady(IOSession p0);
    void timeout(IOSession p0, Timeout p1);
}
