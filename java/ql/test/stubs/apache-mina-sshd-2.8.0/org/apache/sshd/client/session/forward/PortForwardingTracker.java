// Generated automatically from org.apache.sshd.client.session.forward.PortForwardingTracker for testing purposes

package org.apache.sshd.client.session.forward;

import java.nio.channels.Channel;
import java.util.concurrent.atomic.AtomicBoolean;
import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.client.session.ClientSessionHolder;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.SessionHolder;
import org.apache.sshd.common.util.net.SshdSocketAddress;

abstract public class PortForwardingTracker implements Channel, ClientSessionHolder, SessionHolder<ClientSession>
{
    protected PortForwardingTracker() {}
    protected PortForwardingTracker(ClientSession p0, SshdSocketAddress p1, SshdSocketAddress p2){}
    protected final AtomicBoolean open = null;
    public ClientSession getClientSession(){ return null; }
    public ClientSession getSession(){ return null; }
    public SshdSocketAddress getBoundAddress(){ return null; }
    public SshdSocketAddress getLocalAddress(){ return null; }
    public String toString(){ return null; }
    public boolean isOpen(){ return false; }
}
