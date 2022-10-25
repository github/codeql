// Generated automatically from org.apache.sshd.common.forward.PortForwardingManager for testing purposes

package org.apache.sshd.common.forward;

import org.apache.sshd.common.forward.PortForwardingInformationProvider;
import org.apache.sshd.common.util.net.SshdSocketAddress;

public interface PortForwardingManager extends PortForwardingInformationProvider
{
    SshdSocketAddress startDynamicPortForwarding(SshdSocketAddress p0);
    SshdSocketAddress startLocalPortForwarding(SshdSocketAddress p0, SshdSocketAddress p1);
    SshdSocketAddress startRemotePortForwarding(SshdSocketAddress p0, SshdSocketAddress p1);
    default SshdSocketAddress startLocalPortForwarding(int p0, SshdSocketAddress p1){ return null; }
    void stopDynamicPortForwarding(SshdSocketAddress p0);
    void stopLocalPortForwarding(SshdSocketAddress p0);
    void stopRemotePortForwarding(SshdSocketAddress p0);
}
