// Generated automatically from org.apache.sshd.common.session.helpers.SessionTimeoutListener for testing purposes

package org.apache.sshd.common.session.helpers;

import java.util.Set;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.SessionListener;
import org.apache.sshd.common.session.helpers.SessionHelper;
import org.apache.sshd.common.util.logging.AbstractLoggingBean;

public class SessionTimeoutListener extends AbstractLoggingBean implements Runnable, SessionListener
{
    protected final Set<SessionHelper> sessions = null;
    public SessionTimeoutListener(){}
    public void run(){}
    public void sessionClosed(Session p0){}
    public void sessionCreated(Session p0){}
    public void sessionException(Session p0, Throwable p1){}
}
