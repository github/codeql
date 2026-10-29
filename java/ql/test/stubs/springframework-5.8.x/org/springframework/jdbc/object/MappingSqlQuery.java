// Generated automatically from org.springframework.jdbc.object.MappingSqlQuery for testing purposes

package org.springframework.jdbc.object;

import java.sql.ResultSet;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.jdbc.object.MappingSqlQueryWithParameters;

abstract public class MappingSqlQuery<T> extends MappingSqlQueryWithParameters<T>
{
    protected abstract T mapRow(ResultSet p0, int p1);
    protected final T mapRow(ResultSet p0, int p1, Object[] p2, Map<? extends Object, ? extends Object> p3){ return null; }
    public MappingSqlQuery(){}
    public MappingSqlQuery(DataSource p0, String p1){}
}
