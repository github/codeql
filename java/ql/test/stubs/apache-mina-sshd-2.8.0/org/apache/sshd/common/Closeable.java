// Generated automatically from org.apache.sshd.common.Closeable for testing purposes

package org.apache.sshd.common;

import java.nio.channels.Channel;
import java.time.Duration;
import org.apache.sshd.common.PropertyResolver;
import org.apache.sshd.common.future.CloseFuture;
import org.apache.sshd.common.future.SshFuture;
import org.apache.sshd.common.future.SshFutureListener;

public interface Closeable extends Channel
{
    CloseFuture close(boolean p0);
    boolean isClosed();
    boolean isClosing();
    default boolean isOpen(){ return false; }
    default void close(){}
    static Duration getMaxCloseWaitTime(PropertyResolver p0){ return null; }
    static void close(Closeable p0){}
    void addCloseFutureListener(SshFutureListener<CloseFuture> p0);
    void removeCloseFutureListener(SshFutureListener<CloseFuture> p0);
}
