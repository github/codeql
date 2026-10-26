// Generated automatically from org.apache.hadoop.ipc.metrics.RpcMetrics for testing purposes

package org.apache.hadoop.ipc.metrics;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.metrics2.lib.MutableRate;

public class RpcMetrics
{
    protected RpcMetrics() {}
    public MutableRate getDeferredRpcProcessingTime(){ return null; }
    public MutableRate getRpcProcessingTime(){ return null; }
    public String name(){ return null; }
    public String numOpenConnectionsPerUser(){ return null; }
    public double getDeferredRpcProcessingMean(){ return 0; }
    public double getDeferredRpcProcessingStdDev(){ return 0; }
    public double getProcessingMean(){ return 0; }
    public double getProcessingStdDev(){ return 0; }
    public int callQueueLength(){ return 0; }
    public int numOpenConnections(){ return 0; }
    public long getDeferredRpcProcessingSampleCount(){ return 0; }
    public long getProcessingSampleCount(){ return 0; }
    public long getRpcSlowCalls(){ return 0; }
    public long numDroppedConnections(){ return 0; }
    public static RpcMetrics create(org.apache.hadoop.ipc.Server p0, Configuration p1){ return null; }
    public void addDeferredRpcProcessingTime(long p0){}
    public void addRpcProcessingTime(int p0){}
    public void addRpcQueueTime(int p0){}
    public void incrAuthenticationFailures(){}
    public void incrAuthenticationSuccesses(){}
    public void incrAuthorizationFailures(){}
    public void incrAuthorizationSuccesses(){}
    public void incrClientBackoff(){}
    public void incrReceivedBytes(int p0){}
    public void incrSentBytes(int p0){}
    public void incrSlowRpc(){}
    public void shutdown(){}
}
