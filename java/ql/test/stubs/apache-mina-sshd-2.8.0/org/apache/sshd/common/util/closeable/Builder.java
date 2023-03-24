// Generated automatically from org.apache.sshd.common.util.closeable.Builder for testing purposes

package org.apache.sshd.common.util.closeable;

import org.apache.sshd.common.Closeable;
import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.util.ObjectBuilder;

public class Builder implements ObjectBuilder<Closeable>
{
    protected Builder() {}
    public <T extends SshFuture> Builder when(Object p0, Iterable<? extends SshFuture<T>> p1){ return null; }
    public <T extends SshFuture> Builder when(SshFuture<T> p0){ return null; }
    public Builder close(Closeable p0){ return null; }
    public Builder parallel(Closeable... p0){ return null; }
    public Builder parallel(Object p0, Iterable<? extends Closeable> p1){ return null; }
    public Builder run(Object p0, Runnable p1){ return null; }
    public Builder sequential(Closeable... p0){ return null; }
    public Builder sequential(Object p0, Iterable<Closeable> p1){ return null; }
    public Builder(Object p0){}
    public Closeable build(){ return null; }
    public final <T extends SshFuture> Builder when(SshFuture<T>... p0){ return null; }
}
