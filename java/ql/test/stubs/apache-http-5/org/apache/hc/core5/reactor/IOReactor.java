// Generated automatically from org.apache.hc.core5.reactor.IOReactor for testing purposes

package org.apache.hc.core5.reactor;

import org.apache.hc.core5.io.CloseMode;
import org.apache.hc.core5.io.ModalCloseable;
import org.apache.hc.core5.reactor.IOReactorStatus;
import org.apache.hc.core5.util.TimeValue;

public interface IOReactor extends ModalCloseable
{
    IOReactorStatus getStatus();
    void awaitShutdown(TimeValue p0);
    void close(CloseMode p0);
    void initiateShutdown();
}
