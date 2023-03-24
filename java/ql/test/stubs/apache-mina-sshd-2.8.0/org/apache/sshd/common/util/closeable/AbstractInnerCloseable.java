// Generated automatically from org.apache.sshd.common.util.closeable.AbstractInnerCloseable for testing purposes

package org.apache.sshd.common.util.closeable;

import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.future.CloseFuture;
import org.apache.sshd.common.util.closeable.AbstractCloseable;

abstract public class AbstractInnerCloseable extends AbstractCloseable
{
    protected AbstractInnerCloseable(){}
    protected AbstractInnerCloseable(String p0){}
    protected abstract Closeable getInnerCloseable();
    protected final CloseFuture doCloseGracefully(){ return null; }
    protected final void doCloseImmediately(){}
}
