// Generated automatically from org.apache.sshd.common.session.helpers.AbstractSessionIoHandler for testing purposes

package org.apache.sshd.common.session.helpers;

import org.apache.sshd.common.io.IoHandler;
import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.session.helpers.AbstractSession;
import org.apache.sshd.common.util.Readable;
import org.apache.sshd.common.util.logging.AbstractLoggingBean;

abstract public class AbstractSessionIoHandler extends AbstractLoggingBean implements IoHandler
{
    protected AbstractSessionIoHandler(){}
    protected abstract AbstractSession createSession(IoSession p0);
    public void exceptionCaught(IoSession p0, Throwable p1){}
    public void messageReceived(IoSession p0, Readable p1){}
    public void sessionClosed(IoSession p0){}
    public void sessionCreated(IoSession p0){}
}
