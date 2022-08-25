// Generated automatically from org.apache.sshd.common.io.AbstractIoWriteFuture for testing purposes

package org.apache.sshd.common.io;

import org.apache.sshd.common.future.DefaultVerifiableSshFuture;
import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.io.IoWriteFuture;

abstract public class AbstractIoWriteFuture extends DefaultVerifiableSshFuture<IoWriteFuture> implements IoWriteFuture
{
    protected AbstractIoWriteFuture() {}
    protected AbstractIoWriteFuture(Object p0, Object p1){}
    public IoWriteFuture verify(long p0){ return null; }
    public Throwable getException(){ return null; }
    public boolean isWritten(){ return false; }
}
