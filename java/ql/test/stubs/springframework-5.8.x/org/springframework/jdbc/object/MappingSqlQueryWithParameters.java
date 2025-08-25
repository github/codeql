// Generated automatically from org.springframework.jdbc.object.MappingSqlQueryWithParameters for testing purposes

package org.springframework.jdbc.object;

import java.sql.ResultSet;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.object.SqlQuery;

abstract public class MappingSqlQueryWithParameters<T> extends SqlQuery<T>
{
    protected RowMapper<T> newRowMapper(Object[] p0, Map<? extends Object, ? extends Object> p1){ return null; }
    protected abstract T mapRow(ResultSet p0, int p1, Object[] p2, Map<? extends Object, ? extends Object> p3);
    public MappingSqlQueryWithParameters(){}
    public MappingSqlQueryWithParameters(DataSource p0, String p1){}
}
