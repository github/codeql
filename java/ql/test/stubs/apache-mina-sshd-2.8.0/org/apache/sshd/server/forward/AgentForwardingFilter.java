// Generated automatically from org.apache.sshd.server.forward.AgentForwardingFilter for testing purposes

package org.apache.sshd.server.forward;

import org.apache.sshd.common.session.Session;

public interface AgentForwardingFilter
{
    boolean canForwardAgent(Session p0, String p1);
    static AgentForwardingFilter DEFAULT = null;
    static AgentForwardingFilter of(boolean p0){ return null; }
}
