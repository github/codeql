// Generated automatically from com.zaxxer.hikari.HikariConfig for testing purposes

package com.zaxxer.hikari;

import com.zaxxer.hikari.HikariConfigMXBean;
import com.zaxxer.hikari.metrics.MetricsTrackerFactory;
import java.util.Properties;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.ThreadFactory;
import javax.sql.DataSource;

public class HikariConfig implements HikariConfigMXBean
{
    protected void loadProperties(String p0){}
    public DataSource getDataSource(){ return null; }
    public HikariConfig(){}
    public HikariConfig(Properties p0){}
    public HikariConfig(String p0){}
    public MetricsTrackerFactory getMetricsTrackerFactory(){ return null; }
    public Object getHealthCheckRegistry(){ return null; }
    public Object getMetricRegistry(){ return null; }
    public Properties getDataSourceProperties(){ return null; }
    public Properties getHealthCheckProperties(){ return null; }
    public ScheduledExecutorService getScheduledExecutor(){ return null; }
    public ScheduledThreadPoolExecutor getScheduledExecutorService(){ return null; }
    public String getCatalog(){ return null; }
    public String getConnectionInitSql(){ return null; }
    public String getConnectionTestQuery(){ return null; }
    public String getDataSourceClassName(){ return null; }
    public String getDataSourceJNDI(){ return null; }
    public String getDriverClassName(){ return null; }
    public String getJdbcUrl(){ return null; }
    public String getPassword(){ return null; }
    public String getPoolName(){ return null; }
    public String getTransactionIsolation(){ return null; }
    public String getUsername(){ return null; }
    public ThreadFactory getThreadFactory(){ return null; }
    public boolean isAllowPoolSuspension(){ return false; }
    public boolean isAutoCommit(){ return false; }
    public boolean isInitializationFailFast(){ return false; }
    public boolean isIsolateInternalQueries(){ return false; }
    public boolean isJdbc4ConnectionTest(){ return false; }
    public boolean isReadOnly(){ return false; }
    public boolean isRegisterMbeans(){ return false; }
    public int getMaximumPoolSize(){ return 0; }
    public int getMinimumIdle(){ return 0; }
    public long getConnectionTimeout(){ return 0; }
    public long getIdleTimeout(){ return 0; }
    public long getInitializationFailTimeout(){ return 0; }
    public long getLeakDetectionThreshold(){ return 0; }
    public long getMaxLifetime(){ return 0; }
    public long getValidationTimeout(){ return 0; }
    public void addDataSourceProperty(String p0, Object p1){}
    public void addHealthCheckProperty(String p0, String p1){}
    public void copyState(HikariConfig p0){}
    public void setAllowPoolSuspension(boolean p0){}
    public void setAutoCommit(boolean p0){}
    public void setCatalog(String p0){}
    public void setConnectionInitSql(String p0){}
    public void setConnectionTestQuery(String p0){}
    public void setConnectionTimeout(long p0){}
    public void setDataSource(DataSource p0){}
    public void setDataSourceClassName(String p0){}
    public void setDataSourceJNDI(String p0){}
    public void setDataSourceProperties(Properties p0){}
    public void setDriverClassName(String p0){}
    public void setHealthCheckProperties(Properties p0){}
    public void setHealthCheckRegistry(Object p0){}
    public void setIdleTimeout(long p0){}
    public void setInitializationFailFast(boolean p0){}
    public void setInitializationFailTimeout(long p0){}
    public void setIsolateInternalQueries(boolean p0){}
    public void setJdbc4ConnectionTest(boolean p0){}
    public void setJdbcUrl(String p0){}
    public void setLeakDetectionThreshold(long p0){}
    public void setMaxLifetime(long p0){}
    public void setMaximumPoolSize(int p0){}
    public void setMetricRegistry(Object p0){}
    public void setMetricsTrackerFactory(MetricsTrackerFactory p0){}
    public void setMinimumIdle(int p0){}
    public void setPassword(String p0){}
    public void setPoolName(String p0){}
    public void setReadOnly(boolean p0){}
    public void setRegisterMbeans(boolean p0){}
    public void setScheduledExecutor(ScheduledExecutorService p0){}
    public void setScheduledExecutorService(ScheduledThreadPoolExecutor p0){}
    public void setThreadFactory(ThreadFactory p0){}
    public void setTransactionIsolation(String p0){}
    public void setUsername(String p0){}
    public void setValidationTimeout(long p0){}
    public void validate(){}
}
