// Generated automatically from org.apache.sshd.client.future.AuthFuture for testing purposes

package org.apache.sshd.client.future;

import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.VerifiableFuture;

public interface AuthFuture extends SshFuture<AuthFuture>, VerifiableFuture<AuthFuture>
{
    Throwable getException();
    boolean isCanceled();
    boolean isFailure();
    boolean isSuccess();
    void cancel();
    void setAuthed(boolean p0);
    void setException(Throwable p0);
}
