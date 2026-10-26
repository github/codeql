// Generated automatically from org.springframework.jdbc.datasource.AbstractDataSource for testing purposes

package org.springframework.jdbc.datasource;

import java.io.PrintWriter;
import java.util.logging.Logger;
import javax.sql.DataSource;
import org.apache.commons.logging.Log;

abstract public class AbstractDataSource implements DataSource
{
    protected final Log logger = null;
    public <T> T unwrap(java.lang.Class<T> p0){ return null; }
    public AbstractDataSource(){}
    public Logger getParentLogger(){ return null; }
    public PrintWriter getLogWriter(){ return null; }
    public boolean isWrapperFor(Class<? extends Object> p0){ return false; }
    public int getLoginTimeout(){ return 0; }
    public void setLogWriter(PrintWriter p0){}
    public void setLoginTimeout(int p0){}
}
