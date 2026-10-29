// Generated automatically from com.zaxxer.hikari.metrics.PoolStats for testing purposes

package com.zaxxer.hikari.metrics;


abstract public class PoolStats
{
    protected PoolStats() {}
    protected abstract void update();
    protected int activeConnections = 0;
    protected int idleConnections = 0;
    protected int pendingThreads = 0;
    protected int totalConnections = 0;
    public PoolStats(long p0){}
    public int getActiveConnections(){ return 0; }
    public int getIdleConnections(){ return 0; }
    public int getPendingThreads(){ return 0; }
    public int getTotalConnections(){ return 0; }
}
