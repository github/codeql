// Generated automatically from org.apache.sshd.common.session.helpers.PendingWriteFuture for testing purposes

package org.apache.sshd.common.session.helpers;

import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.SshFutureListener;
import org.apache.sshd.common.io.AbstractIoWriteFuture;
import org.apache.sshd.common.io.IoWriteFuture;
import org.apache.sshd.common.util.buffer.Buffer;

public class PendingWriteFuture extends AbstractIoWriteFuture implements SshFutureListener<IoWriteFuture>
{
    protected PendingWriteFuture() {}
    public Buffer getBuffer(){ return null; }
    public PendingWriteFuture(Object p0, Buffer p1){}
    public void operationComplete(IoWriteFuture p0){}
    public void setException(Throwable p0){}
    public void setWritten(){}
}
