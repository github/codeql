// Generated automatically from org.springframework.jdbc.object.SqlQuery for testing purposes

package org.springframework.jdbc.object;

import java.util.List;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.object.SqlOperation;

abstract public class SqlQuery<T> extends SqlOperation
{
    protected abstract RowMapper<T> newRowMapper(Object[] p0, Map<? extends Object, ? extends Object> p1);
    public List<T> execute(){ return null; }
    public List<T> execute(Map<? extends Object, ? extends Object> p0){ return null; }
    public List<T> execute(Object... p0){ return null; }
    public List<T> execute(Object[] p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public List<T> execute(String p0){ return null; }
    public List<T> execute(String p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public List<T> execute(int p0){ return null; }
    public List<T> execute(int p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public List<T> execute(int p0, int p1){ return null; }
    public List<T> execute(int p0, int p1, Map<? extends Object, ? extends Object> p2){ return null; }
    public List<T> execute(long p0){ return null; }
    public List<T> execute(long p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public List<T> executeByNamedParam(Map<String, ? extends Object> p0){ return null; }
    public List<T> executeByNamedParam(Map<String, ? extends Object> p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public SqlQuery(){}
    public SqlQuery(DataSource p0, String p1){}
    public T findObject(Object... p0){ return null; }
    public T findObject(Object[] p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public T findObject(String p0){ return null; }
    public T findObject(String p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public T findObject(int p0){ return null; }
    public T findObject(int p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public T findObject(int p0, int p1){ return null; }
    public T findObject(int p0, int p1, Map<? extends Object, ? extends Object> p2){ return null; }
    public T findObject(long p0){ return null; }
    public T findObject(long p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public T findObjectByNamedParam(Map<String, ? extends Object> p0){ return null; }
    public T findObjectByNamedParam(Map<String, ? extends Object> p0, Map<? extends Object, ? extends Object> p1){ return null; }
    public int getRowsExpected(){ return 0; }
    public void setRowsExpected(int p0){}
}
