// Generated automatically from javax.jdo.Extent for testing purposes

package javax.jdo;

import java.util.Iterator;
import javax.jdo.FetchPlan;
import javax.jdo.PersistenceManager;

public interface Extent<E> extends java.lang.Iterable<E>
{
    FetchPlan getFetchPlan();
    PersistenceManager getPersistenceManager();
    boolean hasSubclasses();
    java.lang.Class<E> getCandidateClass();
    java.util.Iterator<E> iterator();
    void close(java.util.Iterator<E> p0);
    void closeAll();
}
