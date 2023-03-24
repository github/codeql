// Generated automatically from org.apache.sshd.common.io.IoConnectFuture for testing purposes

package org.apache.sshd.common.io;

import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.io.IoSession;

public interface IoConnectFuture extends SshFuture<IoConnectFuture>
{
    IoSession getSession();
    Throwable getException();
    boolean isCanceled();
    boolean isConnected();
    void cancel();
    void setException(Throwable p0);
    void setSession(IoSession p0);
}
