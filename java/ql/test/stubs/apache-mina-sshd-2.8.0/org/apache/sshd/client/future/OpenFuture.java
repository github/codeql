// Generated automatically from org.apache.sshd.client.future.OpenFuture for testing purposes

package org.apache.sshd.client.future;

import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.VerifiableFuture;

public interface OpenFuture extends SshFuture<OpenFuture>, VerifiableFuture<OpenFuture>
{
    Throwable getException();
    boolean isCanceled();
    boolean isOpened();
    void cancel();
    void setException(Throwable p0);
    void setOpened();
}
