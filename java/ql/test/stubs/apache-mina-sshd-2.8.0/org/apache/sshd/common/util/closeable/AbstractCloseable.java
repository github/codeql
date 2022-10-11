// Generated automatically from org.apache.sshd.common.util.closeable.AbstractCloseable for testing purposes

package org.apache.sshd.common.util.closeable;

import java.util.concurrent.atomic.AtomicReference;
import org.apache.sshd.common.future.CloseFuture;
import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.SshFutureListener;
import org.apache.sshd.common.util.closeable.Builder;
import org.apache.sshd.common.util.closeable.IoBaseCloseable;

abstract public class AbstractCloseable extends IoBaseCloseable
{
    protected AbstractCloseable(){}
    protected AbstractCloseable(String p0){}
    protected Builder builder(){ return null; }
    protected CloseFuture doCloseGracefully(){ return null; }
    protected final AtomicReference<AbstractCloseable.State> state = null;
    protected final CloseFuture closeFuture = null;
    protected final Object futureLock = null;
    protected void doCloseImmediately(){}
    protected void preClose(){}
    public Object getFutureLock(){ return null; }
    public final CloseFuture close(boolean p0){ return null; }
    public final boolean isClosed(){ return false; }
    public final boolean isClosing(){ return false; }
    public void addCloseFutureListener(SshFutureListener<CloseFuture> p0){}
    public void removeCloseFutureListener(SshFutureListener<CloseFuture> p0){}
    static public enum State
    {
        Closed, Graceful, Immediate, Opened;
        private State() {}
    }
}
