// Generated automatically from org.springframework.jdbc.datasource.AbstractDriverBasedDataSource for testing purposes

package org.springframework.jdbc.datasource;

import java.sql.Connection;
import java.util.Properties;
import org.springframework.jdbc.datasource.AbstractDataSource;

abstract public class AbstractDriverBasedDataSource extends AbstractDataSource
{
    protected Connection getConnectionFromDriver(String p0, String p1){ return null; }
    protected abstract Connection getConnectionFromDriver(Properties p0);
    public AbstractDriverBasedDataSource(){}
    public Connection getConnection(){ return null; }
    public Connection getConnection(String p0, String p1){ return null; }
    public Properties getConnectionProperties(){ return null; }
    public String getCatalog(){ return null; }
    public String getPassword(){ return null; }
    public String getSchema(){ return null; }
    public String getUrl(){ return null; }
    public String getUsername(){ return null; }
    public void setCatalog(String p0){}
    public void setConnectionProperties(Properties p0){}
    public void setPassword(String p0){}
    public void setSchema(String p0){}
    public void setUrl(String p0){}
    public void setUsername(String p0){}
}
