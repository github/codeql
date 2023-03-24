// Generated automatically from org.apache.sshd.common.future.SshFuture for testing purposes

package org.apache.sshd.common.future;

import org.apache.sshd.common.future.SshFutureListener;
import org.apache.sshd.common.future.WaitableFuture;

public interface SshFuture<T extends SshFuture> extends WaitableFuture
{
    T addListener(SshFutureListener<T> p0);
    T removeListener(SshFutureListener<T> p0);
}
