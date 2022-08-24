// Generated automatically from org.apache.sshd.common.future.SshFutureListener for testing purposes

package org.apache.sshd.common.future;

import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.util.SshdEventListener;

public interface SshFutureListener<T extends SshFuture> extends SshdEventListener
{
    void operationComplete(T p0);
}
