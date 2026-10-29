// Generated automatically from com.zaxxer.hikari.HikariPoolMXBean for testing purposes

package com.zaxxer.hikari;


public interface HikariPoolMXBean
{
    int getActiveConnections();
    int getIdleConnections();
    int getThreadsAwaitingConnection();
    int getTotalConnections();
    void resumePool();
    void softEvictConnections();
    void suspendPool();
}
