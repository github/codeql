// Generated automatically from org.springframework.jdbc.object.SqlUpdate for testing purposes

package org.springframework.jdbc.object;

import java.util.Map;
import javax.sql.DataSource;
import org.springframework.jdbc.object.SqlOperation;
import org.springframework.jdbc.support.KeyHolder;

public class SqlUpdate extends SqlOperation
{
    protected void checkRowsAffected(int p0){}
    public SqlUpdate(){}
    public SqlUpdate(DataSource p0, String p1){}
    public SqlUpdate(DataSource p0, String p1, int[] p2){}
    public SqlUpdate(DataSource p0, String p1, int[] p2, int p3){}
    public int update(){ return 0; }
    public int update(Object... p0){ return 0; }
    public int update(Object[] p0, KeyHolder p1){ return 0; }
    public int update(String p0){ return 0; }
    public int update(String p0, String p1){ return 0; }
    public int update(int p0){ return 0; }
    public int update(int p0, int p1){ return 0; }
    public int update(long p0){ return 0; }
    public int update(long p0, long p1){ return 0; }
    public int updateByNamedParam(Map<String, ? extends Object> p0){ return 0; }
    public int updateByNamedParam(Map<String, ? extends Object> p0, KeyHolder p1){ return 0; }
    public void setMaxRowsAffected(int p0){}
    public void setRequiredRowsAffected(int p0){}
}
