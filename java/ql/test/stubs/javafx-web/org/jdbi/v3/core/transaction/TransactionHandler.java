// Generated automatically from org.jdbi.v3.core.transaction.TransactionHandler for testing purposes

package org.jdbi.v3.core.transaction;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.HandleCallback;
import org.jdbi.v3.core.transaction.TransactionIsolationLevel;

public interface TransactionHandler
{
    <R, X extends Exception> R inTransaction(Handle p0, TransactionIsolationLevel p1, org.jdbi.v3.core.HandleCallback<R, X> p2);
    <R, X extends Exception> R inTransaction(Handle p0, org.jdbi.v3.core.HandleCallback<R, X> p1);
    boolean isInTransaction(Handle p0);
    default TransactionHandler specialize(Handle p0){ return null; }
    void begin(Handle p0);
    void commit(Handle p0);
    void releaseSavepoint(Handle p0, String p1);
    void rollback(Handle p0);
    void rollbackToSavepoint(Handle p0, String p1);
    void savepoint(Handle p0, String p1);
}
