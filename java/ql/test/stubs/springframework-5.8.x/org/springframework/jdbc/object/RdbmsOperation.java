// Generated automatically from org.springframework.jdbc.object.RdbmsOperation for testing purposes

package org.springframework.jdbc.object;

import java.util.List;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;

abstract public class RdbmsOperation implements InitializingBean
{
    protected List<SqlParameter> getDeclaredParameters(){ return null; }
    protected String resolveSql(){ return null; }
    protected abstract void compileInternal();
    protected boolean allowsUnusedParameters(){ return false; }
    protected boolean supportsLobParameters(){ return false; }
    protected void checkCompiled(){}
    protected void validateNamedParameters(Map<String, ? extends Object> p0){}
    protected void validateParameters(Object[] p0){}
    public JdbcTemplate getJdbcTemplate(){ return null; }
    public RdbmsOperation(){}
    public String getSql(){ return null; }
    public String[] getGeneratedKeysColumnNames(){ return null; }
    public boolean isCompiled(){ return false; }
    public boolean isReturnGeneratedKeys(){ return false; }
    public boolean isUpdatableResults(){ return false; }
    public final void compile(){}
    public int getResultSetType(){ return 0; }
    public void afterPropertiesSet(){}
    public void declareParameter(SqlParameter p0){}
    public void setDataSource(DataSource p0){}
    public void setFetchSize(int p0){}
    public void setGeneratedKeysColumnNames(String... p0){}
    public void setJdbcTemplate(JdbcTemplate p0){}
    public void setMaxRows(int p0){}
    public void setParameters(SqlParameter... p0){}
    public void setQueryTimeout(int p0){}
    public void setResultSetType(int p0){}
    public void setReturnGeneratedKeys(boolean p0){}
    public void setSql(String p0){}
    public void setTypes(int[] p0){}
    public void setUpdatableResults(boolean p0){}
}
