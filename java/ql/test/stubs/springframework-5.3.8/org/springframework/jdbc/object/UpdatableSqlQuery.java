// Generated automatically from org.springframework.jdbc.object.UpdatableSqlQuery for testing purposes

package org.springframework.jdbc.object;

import java.sql.ResultSet;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.object.SqlQuery;

abstract public class UpdatableSqlQuery<T> extends SqlQuery<T>
{
    protected RowMapper<T> newRowMapper(Object[] p0, Map<? extends Object, ? extends Object> p1){ return null; }
    protected abstract T updateRow(ResultSet p0, int p1, Map<? extends Object, ? extends Object> p2);
    public UpdatableSqlQuery(){}
    public UpdatableSqlQuery(DataSource p0, String p1){}
}
