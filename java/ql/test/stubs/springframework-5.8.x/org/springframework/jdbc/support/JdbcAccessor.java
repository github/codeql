// Generated automatically from org.springframework.jdbc.support.JdbcAccessor for testing purposes

package org.springframework.jdbc.support;

import javax.sql.DataSource;
import org.apache.commons.logging.Log;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.jdbc.support.SQLExceptionTranslator;

abstract public class JdbcAccessor implements InitializingBean
{
    protected DataSource obtainDataSource(){ return null; }
    protected final Log logger = null;
    public DataSource getDataSource(){ return null; }
    public JdbcAccessor(){}
    public SQLExceptionTranslator getExceptionTranslator(){ return null; }
    public boolean isLazyInit(){ return false; }
    public void afterPropertiesSet(){}
    public void setDataSource(DataSource p0){}
    public void setDatabaseProductName(String p0){}
    public void setExceptionTranslator(SQLExceptionTranslator p0){}
    public void setLazyInit(boolean p0){}
}
