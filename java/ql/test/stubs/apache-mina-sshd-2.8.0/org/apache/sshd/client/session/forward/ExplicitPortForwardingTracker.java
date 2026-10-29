// Generated automatically from org.apache.sshd.client.session.forward.ExplicitPortForwardingTracker for testing purposes

package org.apache.sshd.client.session.forward;

import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.client.session.forward.PortForwardingTracker;
import org.apache.sshd.common.util.net.ConnectionEndpointsIndicator;
import org.apache.sshd.common.util.net.SshdSocketAddress;

public class ExplicitPortForwardingTracker extends PortForwardingTracker implements ConnectionEndpointsIndicator
{
    protected ExplicitPortForwardingTracker() {}
    public ExplicitPortForwardingTracker(ClientSession p0, boolean p1, SshdSocketAddress p2, SshdSocketAddress p3, SshdSocketAddress p4){}
    public SshdSocketAddress getRemoteAddress(){ return null; }
    public String toString(){ return null; }
    public boolean isLocalForwarding(){ return false; }
    public void close(){}
}
