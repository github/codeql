// Generated automatically from org.apache.sshd.common.io.IoHandler for testing purposes

package org.apache.sshd.common.io;

import org.apache.sshd.common.io.IoSession;
import org.apache.sshd.common.util.Readable;

public interface IoHandler
{
    void exceptionCaught(IoSession p0, Throwable p1);
    void messageReceived(IoSession p0, Readable p1);
    void sessionClosed(IoSession p0);
    void sessionCreated(IoSession p0);
}
