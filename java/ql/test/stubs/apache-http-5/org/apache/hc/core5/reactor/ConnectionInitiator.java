// Generated automatically from org.apache.hc.core5.reactor.ConnectionInitiator for testing purposes

package org.apache.hc.core5.reactor;

import java.net.SocketAddress;
import java.util.concurrent.Future;
import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.net.NamedEndpoint;
import org.apache.hc.core5.reactor.IOSession;
import org.apache.hc.core5.util.Timeout;

public interface ConnectionInitiator
{
    Future<IOSession> connect(NamedEndpoint p0, SocketAddress p1, SocketAddress p2, Timeout p3, Object p4, FutureCallback<IOSession> p5);
}
