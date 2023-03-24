// Generated automatically from org.apache.sshd.server.forward.X11ForwardingFilter for testing purposes

package org.apache.sshd.server.forward;

import org.apache.sshd.common.session.Session;

public interface X11ForwardingFilter
{
    boolean canForwardX11(Session p0, String p1);
    static X11ForwardingFilter DEFAULT = null;
    static X11ForwardingFilter of(boolean p0){ return null; }
}
