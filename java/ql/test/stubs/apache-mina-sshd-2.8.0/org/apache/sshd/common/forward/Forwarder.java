// Generated automatically from org.apache.sshd.common.forward.Forwarder for testing purposes

package org.apache.sshd.common.forward;

import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.forward.PortForwardingEventListenerManager;
import org.apache.sshd.common.forward.PortForwardingEventListenerManagerHolder;
import org.apache.sshd.common.forward.PortForwardingManager;
import org.apache.sshd.common.util.net.SshdSocketAddress;

public interface Forwarder extends Closeable, PortForwardingEventListenerManager, PortForwardingEventListenerManagerHolder, PortForwardingManager
{
    SshdSocketAddress getForwardedPort(int p0);
    SshdSocketAddress localPortForwardingRequested(SshdSocketAddress p0);
    void localPortForwardingCancelled(SshdSocketAddress p0);
}
