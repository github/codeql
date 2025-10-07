// Generated automatically from org.springframework.jdbc.object.SqlFunction for testing purposes

package org.springframework.jdbc.object;

import java.sql.ResultSet;
import javax.sql.DataSource;
import org.springframework.jdbc.object.MappingSqlQuery;

public class SqlFunction<T> extends MappingSqlQuery<T>
{
    protected T mapRow(ResultSet p0, int p1){ return null; }
    public Object runGeneric(){ return null; }
    public Object runGeneric(Object[] p0){ return null; }
    public Object runGeneric(int p0){ return null; }
    public SqlFunction(){}
    public SqlFunction(DataSource p0, String p1){}
    public SqlFunction(DataSource p0, String p1, int[] p2){}
    public SqlFunction(DataSource p0, String p1, int[] p2, Class<T> p3){}
    public int run(){ return 0; }
    public int run(Object... p0){ return 0; }
    public int run(int p0){ return 0; }
    public void setResultType(Class<T> p0){}
}
