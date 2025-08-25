// Generated automatically from org.springframework.jdbc.object.SqlOperation for testing purposes

package org.springframework.jdbc.object;

import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.core.namedparam.ParsedSql;
import org.springframework.jdbc.object.RdbmsOperation;

abstract public class SqlOperation extends RdbmsOperation
{
    protected ParsedSql getParsedSql(){ return null; }
    protected final PreparedStatementCreator newPreparedStatementCreator(Object[] p0){ return null; }
    protected final PreparedStatementCreator newPreparedStatementCreator(String p0, Object[] p1){ return null; }
    protected final PreparedStatementSetter newPreparedStatementSetter(Object[] p0){ return null; }
    protected final void compileInternal(){}
    protected void onCompileInternal(){}
    public SqlOperation(){}
}
