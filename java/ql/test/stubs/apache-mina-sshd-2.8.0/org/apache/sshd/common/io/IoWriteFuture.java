// Generated automatically from org.apache.sshd.common.io.IoWriteFuture for testing purposes

package org.apache.sshd.common.io;

import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.VerifiableFuture;

public interface IoWriteFuture extends SshFuture<IoWriteFuture>, VerifiableFuture<IoWriteFuture>
{
    Throwable getException();
    boolean isWritten();
}
