// Generated automatically from com.zaxxer.hikari.HikariConfigMXBean for testing purposes

package com.zaxxer.hikari;


public interface HikariConfigMXBean
{
    String getPoolName();
    int getMaximumPoolSize();
    int getMinimumIdle();
    long getConnectionTimeout();
    long getIdleTimeout();
    long getLeakDetectionThreshold();
    long getMaxLifetime();
    long getValidationTimeout();
    void setConnectionTimeout(long p0);
    void setIdleTimeout(long p0);
    void setLeakDetectionThreshold(long p0);
    void setMaxLifetime(long p0);
    void setMaximumPoolSize(int p0);
    void setMinimumIdle(int p0);
    void setPassword(String p0);
    void setUsername(String p0);
    void setValidationTimeout(long p0);
}
