// Generated automatically from org.apache.sshd.common.future.WaitableFuture for testing purposes

package org.apache.sshd.common.future;

import java.time.Duration;
import java.util.concurrent.TimeUnit;

public interface WaitableFuture
{
    Object getId();
    boolean await(long p0);
    boolean awaitUninterruptibly(long p0);
    boolean isDone();
    default boolean await(){ return false; }
    default boolean await(Duration p0){ return false; }
    default boolean await(long p0, TimeUnit p1){ return false; }
    default boolean awaitUninterruptibly(){ return false; }
    default boolean awaitUninterruptibly(Duration p0){ return false; }
    default boolean awaitUninterruptibly(long p0, TimeUnit p1){ return false; }
}
