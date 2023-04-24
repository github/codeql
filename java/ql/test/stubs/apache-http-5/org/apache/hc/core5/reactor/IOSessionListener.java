// Generated automatically from org.apache.hc.core5.reactor.IOSessionListener for testing purposes

package org.apache.hc.core5.reactor;

import org.apache.hc.core5.reactor.IOSession;

public interface IOSessionListener
{
    void connected(IOSession p0);
    void disconnected(IOSession p0);
    void exception(IOSession p0, Exception p1);
    void inputReady(IOSession p0);
    void outputReady(IOSession p0);
    void startTls(IOSession p0);
    void timeout(IOSession p0);
}
