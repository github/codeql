// Generated automatically from org.apache.hc.core5.reactor.ProtocolUpgradeHandler for testing purposes

package org.apache.hc.core5.reactor;

import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.reactor.ProtocolIOSession;

public interface ProtocolUpgradeHandler
{
    void upgrade(ProtocolIOSession p0, FutureCallback<ProtocolIOSession> p1);
}
