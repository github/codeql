// Generated automatically from org.jdbi.v3.core.statement.PreparedBatch for testing purposes

package org.jdbi.v3.core.statement;

import java.util.Map;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.result.BatchResultBearing;
import org.jdbi.v3.core.result.ResultBearing;
import org.jdbi.v3.core.result.ResultIterator;
import org.jdbi.v3.core.result.ResultProducer;
import org.jdbi.v3.core.result.ResultSetScanner;
import org.jdbi.v3.core.statement.SqlStatement;
import org.jdbi.v3.core.statement.internal.PreparedBinding;

public class PreparedBatch extends SqlStatement<PreparedBatch> implements ResultBearing
{
    protected PreparedBatch() {}
    protected PreparedBinding getBinding(){ return null; }
    public <R> R execute(org.jdbi.v3.core.result.ResultProducer<R> p0){ return null; }
    public <R> R scanResultSet(org.jdbi.v3.core.result.ResultSetScanner<R> p0){ return null; }
    public BatchResultBearing executePreparedBatch(String... p0){ return null; }
    public PreparedBatch add(){ return null; }
    public PreparedBatch add(Map<String, ? extends Object> p0){ return null; }
    public PreparedBatch add(Object... p0){ return null; }
    public PreparedBatch(Handle p0, CharSequence p1){}
    public PreparedBatch(Handle p0, String p1){}
    public ResultBearing executeAndReturnGeneratedKeys(String... p0){ return null; }
    public ResultIterator<Integer> executeAndGetModCount(){ return null; }
    public int size(){ return 0; }
    public int[] execute(){ return null; }
}
