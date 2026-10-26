// Generated automatically from org.apache.hc.core5.pool.ConnPool for testing purposes

package org.apache.hc.core5.pool;

import java.util.concurrent.Future;
import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.io.ModalCloseable;
import org.apache.hc.core5.pool.PoolEntry;
import org.apache.hc.core5.util.Timeout;

public interface ConnPool<T, C extends ModalCloseable>
{
    java.util.concurrent.Future<org.apache.hc.core5.pool.PoolEntry<T, C>> lease(T p0, Object p1, Timeout p2, org.apache.hc.core5.concurrent.FutureCallback<org.apache.hc.core5.pool.PoolEntry<T, C>> p3);
    void release(org.apache.hc.core5.pool.PoolEntry<T, C> p0, boolean p1);
}
