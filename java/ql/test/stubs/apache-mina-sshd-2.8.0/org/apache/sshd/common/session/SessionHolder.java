// Generated automatically from org.apache.sshd.common.session.SessionHolder for testing purposes

package org.apache.sshd.common.session;

import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.SessionContext;
import org.apache.sshd.common.session.SessionContextHolder;

public interface SessionHolder<S extends Session> extends SessionContextHolder
{
    S getSession();
    default SessionContext getSessionContext(){ return null; }
}
