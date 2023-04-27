// Generated automatically from org.jdbi.v3.core.Handle for testing purposes

package org.jdbi.v3.core;

import java.io.Closeable;
import java.sql.Connection;
import org.jdbi.v3.core.HandleCallback;
import org.jdbi.v3.core.HandleConsumer;
import org.jdbi.v3.core.HandleListener;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.config.Configurable;
import org.jdbi.v3.core.extension.ExtensionMethod;
import org.jdbi.v3.core.result.ResultBearing;
import org.jdbi.v3.core.statement.Batch;
import org.jdbi.v3.core.statement.Call;
import org.jdbi.v3.core.statement.Cleanable;
import org.jdbi.v3.core.statement.MetaData;
import org.jdbi.v3.core.statement.PreparedBatch;
import org.jdbi.v3.core.statement.Query;
import org.jdbi.v3.core.statement.Script;
import org.jdbi.v3.core.statement.StatementBuilder;
import org.jdbi.v3.core.statement.Update;
import org.jdbi.v3.core.transaction.TransactionIsolationLevel;

public class Handle implements Closeable, Configurable<Handle>
{
    protected Handle() {}
    public <R, X extends Exception> R inTransaction(TransactionIsolationLevel p0, org.jdbi.v3.core.HandleCallback<R, X> p1){ return null; }
    public <R, X extends Exception> R inTransaction(org.jdbi.v3.core.HandleCallback<R, X> p0){ return null; }
    public <T> T attach(java.lang.Class<T> p0){ return null; }
    public <T> T queryMetadata(MetaData.MetaDataValueProvider<T> p0){ return null; }
    public <X extends Exception> void useTransaction(TransactionIsolationLevel p0, org.jdbi.v3.core.HandleConsumer<X> p1){}
    public <X extends Exception> void useTransaction(org.jdbi.v3.core.HandleConsumer<X> p0){}
    public Batch createBatch(){ return null; }
    public Call createCall(CharSequence p0){ return null; }
    public Call createCall(String p0){ return null; }
    public ConfigRegistry getConfig(){ return null; }
    public Connection getConnection(){ return null; }
    public ExtensionMethod getExtensionMethod(){ return null; }
    public Handle addHandleListener(HandleListener p0){ return null; }
    public Handle afterCommit(Runnable p0){ return null; }
    public Handle afterRollback(Runnable p0){ return null; }
    public Handle begin(){ return null; }
    public Handle commit(){ return null; }
    public Handle release(String p0){ return null; }
    public Handle releaseSavepoint(String p0){ return null; }
    public Handle removeHandleListener(HandleListener p0){ return null; }
    public Handle rollback(){ return null; }
    public Handle rollbackToSavepoint(String p0){ return null; }
    public Handle savepoint(String p0){ return null; }
    public Handle setReadOnly(boolean p0){ return null; }
    public Handle setStatementBuilder(StatementBuilder p0){ return null; }
    public Jdbi getJdbi(){ return null; }
    public PreparedBatch prepareBatch(CharSequence p0){ return null; }
    public PreparedBatch prepareBatch(String p0){ return null; }
    public Query createQuery(CharSequence p0){ return null; }
    public Query createQuery(String p0){ return null; }
    public Query select(CharSequence p0, Object... p1){ return null; }
    public Query select(String p0, Object... p1){ return null; }
    public ResultBearing queryMetadata(MetaData.MetaDataResultSetProvider p0){ return null; }
    public Script createScript(CharSequence p0){ return null; }
    public Script createScript(String p0){ return null; }
    public StatementBuilder getStatementBuilder(){ return null; }
    public TransactionIsolationLevel getTransactionIsolationLevel(){ return null; }
    public Update createUpdate(CharSequence p0){ return null; }
    public Update createUpdate(String p0){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isClean(){ return false; }
    public boolean isClosed(){ return false; }
    public boolean isInTransaction(){ return false; }
    public boolean isReadOnly(){ return false; }
    public final void addCleanable(Cleanable p0){}
    public final void removeCleanable(Cleanable p0){}
    public int execute(CharSequence p0, Object... p1){ return 0; }
    public int execute(String p0, Object... p1){ return 0; }
    public int hashCode(){ return 0; }
    public void clean(){}
    public void close(){}
    public void setTransactionIsolation(TransactionIsolationLevel p0){}
    public void setTransactionIsolation(int p0){}
    public void setTransactionIsolationLevel(TransactionIsolationLevel p0){}
    public void setTransactionIsolationLevel(int p0){}
}
