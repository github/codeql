// Generated automatically from org.apache.sshd.common.future.AbstractSshFuture for testing purposes

package org.apache.sshd.common.future;

import java.util.function.Function;
import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.SshFutureListener;
import org.apache.sshd.common.util.logging.AbstractLoggingBean;

abstract public class AbstractSshFuture<T extends SshFuture> extends AbstractLoggingBean implements SshFuture<T>
{
    protected AbstractSshFuture() {}
    protected <E extends Throwable> E formatExceptionMessage(Function<? super String, ? extends E> p0, String p1, Object... p2){ return null; }
    protected <R> R verifyResult(Class<? extends R> p0, long p1){ return null; }
    protected AbstractSshFuture(Object p0){}
    protected SshFutureListener<T> asListener(Object p0){ return null; }
    protected T asT(){ return null; }
    protected abstract Object await0(long p0, boolean p1);
    protected static Object CANCELED = null;
    protected void notifyListener(SshFutureListener<T> p0){}
    public Object getId(){ return null; }
    public String toString(){ return null; }
    public boolean await(long p0){ return false; }
    public boolean awaitUninterruptibly(long p0){ return false; }
}
