// Generated automatically from org.jdbi.v3.core.statement.Query for testing purposes

package org.jdbi.v3.core.statement;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.result.ResultBearing;
import org.jdbi.v3.core.result.ResultProducer;
import org.jdbi.v3.core.result.ResultSetScanner;
import org.jdbi.v3.core.statement.SqlStatement;

public class Query extends SqlStatement<Query> implements ResultBearing
{
    protected Query() {}
    public <R> R execute(org.jdbi.v3.core.result.ResultProducer<R> p0){ return null; }
    public <R> R scanResultSet(org.jdbi.v3.core.result.ResultSetScanner<R> p0){ return null; }
    public Query concurrentUpdatable(){ return null; }
    public Query setFetchSize(int p0){ return null; }
    public Query setMaxFieldSize(int p0){ return null; }
    public Query setMaxRows(int p0){ return null; }
    public Query(Handle p0, CharSequence p1){}
    public Query(Handle p0, String p1){}
}
