// Generated automatically from javax.jdo.datastore.DataStoreCache for testing purposes

package javax.jdo.datastore;

import java.util.Collection;

public interface DataStoreCache
{
    void evict(Object p0);
    void evictAll();
    void evictAll(Collection p0);
    void evictAll(Object... p0);
    void evictAll(boolean p0, Class p1);
    void pin(Object p0);
    void pinAll(Collection p0);
    void pinAll(Object... p0);
    void pinAll(boolean p0, Class p1);
    void unpin(Object p0);
    void unpinAll(Collection p0);
    void unpinAll(Object... p0);
    void unpinAll(boolean p0, Class p1);
}
