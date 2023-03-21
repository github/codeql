// Generated automatically from com.zaxxer.hikari.HikariDataSource for testing purposes

package com.zaxxer.hikari;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariConfigMXBean;
import com.zaxxer.hikari.HikariPoolMXBean;
import com.zaxxer.hikari.metrics.MetricsTrackerFactory;
import java.io.Closeable;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.logging.Logger;
import javax.sql.DataSource;

public class HikariDataSource extends HikariConfig implements Closeable, DataSource
{
    public <T> T unwrap(java.lang.Class<T> p0){ return null; }
    public Connection getConnection(){ return null; }
    public Connection getConnection(String p0, String p1){ return null; }
    public HikariConfigMXBean getHikariConfigMXBean(){ return null; }
    public HikariDataSource(){}
    public HikariDataSource(HikariConfig p0){}
    public HikariPoolMXBean getHikariPoolMXBean(){ return null; }
    public Logger getParentLogger(){ return null; }
    public PrintWriter getLogWriter(){ return null; }
    public String toString(){ return null; }
    public boolean isClosed(){ return false; }
    public boolean isWrapperFor(Class<? extends Object> p0){ return false; }
    public int getLoginTimeout(){ return 0; }
    public void close(){}
    public void evictConnection(Connection p0){}
    public void resumePool(){}
    public void setHealthCheckRegistry(Object p0){}
    public void setLogWriter(PrintWriter p0){}
    public void setLoginTimeout(int p0){}
    public void setMetricRegistry(Object p0){}
    public void setMetricsTrackerFactory(MetricsTrackerFactory p0){}
    public void shutdown(){}
    public void suspendPool(){}
}
