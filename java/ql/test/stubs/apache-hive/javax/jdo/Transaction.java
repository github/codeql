// Generated automatically from javax.jdo.Transaction for testing purposes

package javax.jdo;

import javax.jdo.PersistenceManager;
import javax.transaction.Synchronization;

public interface Transaction
{
    Boolean getSerializeRead();
    PersistenceManager getPersistenceManager();
    String getIsolationLevel();
    Synchronization getSynchronization();
    boolean getNontransactionalRead();
    boolean getNontransactionalWrite();
    boolean getOptimistic();
    boolean getRestoreValues();
    boolean getRetainValues();
    boolean getRollbackOnly();
    boolean isActive();
    void begin();
    void commit();
    void rollback();
    void setIsolationLevel(String p0);
    void setNontransactionalRead(boolean p0);
    void setNontransactionalWrite(boolean p0);
    void setOptimistic(boolean p0);
    void setRestoreValues(boolean p0);
    void setRetainValues(boolean p0);
    void setRollbackOnly();
    void setSerializeRead(Boolean p0);
    void setSynchronization(Synchronization p0);
}
