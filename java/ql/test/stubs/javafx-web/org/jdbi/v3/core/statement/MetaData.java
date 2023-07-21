// Generated automatically from org.jdbi.v3.core.statement.MetaData for testing purposes

package org.jdbi.v3.core.statement;

import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.result.ResultBearing;
import org.jdbi.v3.core.result.ResultSetScanner;
import org.jdbi.v3.core.statement.BaseStatement;

public class MetaData extends BaseStatement<MetaData> implements ResultBearing
{
    protected MetaData() {}
    public <R> R execute(){ return null; }
    public <R> R scanResultSet(org.jdbi.v3.core.result.ResultSetScanner<R> p0){ return null; }
    public MetaData(Handle p0, MetaData.MetaDataValueProvider<? extends Object> p1){}
    static public interface MetaDataResultSetProvider extends MetaData.MetaDataValueProvider<ResultSet>
    {
        ResultSet provideValue(DatabaseMetaData p0);
    }
    static public interface MetaDataValueProvider<T>
    {
        T provideValue(DatabaseMetaData p0);
    }
}
