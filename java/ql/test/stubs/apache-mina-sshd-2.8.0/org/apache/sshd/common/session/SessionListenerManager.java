// Generated automatically from org.apache.sshd.common.session.SessionListenerManager for testing purposes

package org.apache.sshd.common.session;

import org.apache.sshd.common.session.SessionListener;

public interface SessionListenerManager
{
    SessionListener getSessionListenerProxy();
    void addSessionListener(SessionListener p0);
    void removeSessionListener(SessionListener p0);
}
