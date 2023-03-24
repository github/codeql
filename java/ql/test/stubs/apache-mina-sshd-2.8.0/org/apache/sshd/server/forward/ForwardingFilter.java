// Generated automatically from org.apache.sshd.server.forward.ForwardingFilter for testing purposes

package org.apache.sshd.server.forward;

import org.apache.sshd.server.forward.AgentForwardingFilter;
import org.apache.sshd.server.forward.TcpForwardingFilter;
import org.apache.sshd.server.forward.X11ForwardingFilter;

public interface ForwardingFilter extends AgentForwardingFilter, TcpForwardingFilter, X11ForwardingFilter
{
    static ForwardingFilter asForwardingFilter(AgentForwardingFilter p0, X11ForwardingFilter p1, TcpForwardingFilter p2){ return null; }
}
