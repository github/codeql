// Generated automatically from org.apache.sshd.common.forward.PortForwardingEventListener for testing purposes

package org.apache.sshd.common.forward;

import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.util.SshdEventListener;
import org.apache.sshd.common.util.net.SshdSocketAddress;

public interface PortForwardingEventListener extends SshdEventListener
{
    default void establishedDynamicTunnel(Session p0, SshdSocketAddress p1, SshdSocketAddress p2, Throwable p3){}
    default void establishedExplicitTunnel(Session p0, SshdSocketAddress p1, SshdSocketAddress p2, boolean p3, SshdSocketAddress p4, Throwable p5){}
    default void establishingDynamicTunnel(Session p0, SshdSocketAddress p1){}
    default void establishingExplicitTunnel(Session p0, SshdSocketAddress p1, SshdSocketAddress p2, boolean p3){}
    default void tearingDownDynamicTunnel(Session p0, SshdSocketAddress p1){}
    default void tearingDownExplicitTunnel(Session p0, SshdSocketAddress p1, boolean p2, SshdSocketAddress p3){}
    default void tornDownDynamicTunnel(Session p0, SshdSocketAddress p1, Throwable p2){}
    default void tornDownExplicitTunnel(Session p0, SshdSocketAddress p1, boolean p2, SshdSocketAddress p3, Throwable p4){}
    static <L extends PortForwardingEventListener> L validateListener(L p0){ return null; }
    static PortForwardingEventListener EMPTY = null;
}
