// Generated automatically from org.apache.sshd.common.io.IoReadFuture for testing purposes

package org.apache.sshd.common.io;

import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.VerifiableFuture;
import org.apache.sshd.common.util.buffer.Buffer;

public interface IoReadFuture extends SshFuture<IoReadFuture>, VerifiableFuture<IoReadFuture>
{
    Buffer getBuffer();
    Throwable getException();
    int getRead();
}
