// Generated automatically from org.apache.sshd.common.session.ConnectionService for testing purposes

package org.apache.sshd.common.session;

import org.apache.sshd.agent.common.AgentForwardSupport;
import org.apache.sshd.common.Service;
import org.apache.sshd.common.channel.Channel;
import org.apache.sshd.common.forward.Forwarder;
import org.apache.sshd.common.forward.PortForwardingEventListenerManager;
import org.apache.sshd.common.forward.PortForwardingEventListenerManagerHolder;
import org.apache.sshd.common.session.SessionHeartbeatController;
import org.apache.sshd.common.session.UnknownChannelReferenceHandlerManager;
import org.apache.sshd.server.x11.X11ForwardSupport;

public interface ConnectionService extends PortForwardingEventListenerManager, PortForwardingEventListenerManagerHolder, Service, SessionHeartbeatController, UnknownChannelReferenceHandlerManager
{
    AgentForwardSupport getAgentForwardSupport();
    Forwarder getForwarder();
    X11ForwardSupport getX11ForwardSupport();
    boolean isAllowMoreSessions();
    int registerChannel(Channel p0);
    void setAllowMoreSessions(boolean p0);
    void unregisterChannel(Channel p0);
}
