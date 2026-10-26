// Generated automatically from org.apache.hc.core5.pool.PoolEntry for testing purposes

package org.apache.hc.core5.pool;

import org.apache.hc.core5.io.CloseMode;
import org.apache.hc.core5.io.ModalCloseable;
import org.apache.hc.core5.pool.DisposalCallback;
import org.apache.hc.core5.util.Deadline;
import org.apache.hc.core5.util.TimeValue;

public class PoolEntry<T, C extends ModalCloseable>
{
    protected PoolEntry() {}
    public C getConnection(){ return null; }
    public Deadline getExpiryDeadline(){ return null; }
    public Deadline getValidityDeadline(){ return null; }
    public Object getState(){ return null; }
    public PoolEntry(T p0){}
    public PoolEntry(T p0, TimeValue p1){}
    public PoolEntry(T p0, TimeValue p1, DisposalCallback<C> p2){}
    public String toString(){ return null; }
    public T getRoute(){ return null; }
    public boolean hasConnection(){ return false; }
    public long getCreated(){ return 0; }
    public long getUpdated(){ return 0; }
    public void assignConnection(C p0){}
    public void discardConnection(CloseMode p0){}
    public void updateExpiry(TimeValue p0){}
    public void updateState(Object p0){}
}
