// Generated automatically from org.apache.hc.core5.reactor.ProtocolIOSession for testing purposes

package org.apache.hc.core5.reactor;

import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.net.NamedEndpoint;
import org.apache.hc.core5.reactor.IOSession;
import org.apache.hc.core5.reactor.ProtocolUpgradeHandler;
import org.apache.hc.core5.reactor.ssl.TransportSecurityLayer;

public interface ProtocolIOSession extends IOSession, TransportSecurityLayer
{
    NamedEndpoint getInitialEndpoint();
    default void registerProtocol(String p0, ProtocolUpgradeHandler p1){}
    default void switchProtocol(String p0, FutureCallback<ProtocolIOSession> p1){}
}
