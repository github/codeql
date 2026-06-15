// Generated automatically from org.apache.sshd.common.util.threads.CloseableExecutorService for testing purposes

package org.apache.sshd.common.util.threads;

import java.time.Duration;
import java.util.concurrent.ExecutorService;
import org.apache.sshd.common.Closeable;

public interface CloseableExecutorService extends Closeable, ExecutorService
{
    default boolean awaitTermination(Duration p0){ return false; }

    default void close() { }
}
