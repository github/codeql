// Generated automatically from org.apache.sshd.client.future.ConnectFuture for testing purposes

package org.apache.sshd.client.future;

import org.apache.sshd.client.session.ClientSession;
import org.apache.sshd.client.session.ClientSessionHolder;
import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.VerifiableFuture;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.SessionHolder;

public interface ConnectFuture extends ClientSessionHolder, SessionHolder<ClientSession>, SshFuture<ConnectFuture>, VerifiableFuture<ConnectFuture>
{
    Throwable getException();
    boolean isCanceled();
    boolean isConnected();
    default ClientSession getClientSession(){ return null; }
    void cancel();
    void setException(Throwable p0);
    void setSession(ClientSession p0);
}
