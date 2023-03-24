// Generated automatically from org.apache.sshd.common.future.VerifiableFuture for testing purposes

package org.apache.sshd.common.future;

import java.time.Duration;
import java.util.concurrent.TimeUnit;

public interface VerifiableFuture<T>
{
    T verify(long p0);
    default T verify(){ return null; }
    default T verify(Duration p0){ return null; }
    default T verify(long p0, TimeUnit p1){ return null; }
}
