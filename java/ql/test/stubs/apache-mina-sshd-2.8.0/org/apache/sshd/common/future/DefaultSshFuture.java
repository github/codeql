// Generated automatically from org.apache.sshd.common.future.DefaultSshFuture for testing purposes

package org.apache.sshd.common.future;

import org.apache.sshd.common.future.AbstractSshFuture;
import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.SshFutureListener;

public class DefaultSshFuture<T extends SshFuture> extends AbstractSshFuture<T>
{
    protected DefaultSshFuture() {}
    protected Object await0(long p0, boolean p1){ return null; }
    protected void notifyListeners(){}
    public DefaultSshFuture(Object p0, Object p1){}
    public Object getValue(){ return null; }
    public String toString(){ return null; }
    public T addListener(SshFutureListener<T> p0){ return null; }
    public T removeListener(SshFutureListener<T> p0){ return null; }
    public boolean isCanceled(){ return false; }
    public boolean isDone(){ return false; }
    public int getNumRegisteredListeners(){ return 0; }
    public void cancel(){}
    public void setValue(Object p0){}
}
