// Generated automatically from org.apache.hadoop.ipc.Client for testing purposes

package org.apache.hadoop.ipc;

import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.atomic.AtomicBoolean;
import javax.net.SocketFactory;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.ipc.RPC;
import org.apache.hadoop.util.concurrent.AsyncGet;
import org.slf4j.Logger;

public class Client implements AutoCloseable
{
    protected Client() {}
    public Client(Class<? extends Writable> p0, Configuration p1){}
    public Client(Class<? extends Writable> p0, Configuration p1, SocketFactory p2){}
    public Writable call(RPC.RpcKind p0, Writable p1, Client.ConnectionId p2, AtomicBoolean p3){ return null; }
    public static <T extends Writable> AsyncGet<T, IOException> getAsyncRpcResponse(){ return null; }
    public static ExecutorService getClientExecutor(){ return null; }
    public static Logger LOG = null;
    public static boolean isAsynchronousMode(){ return false; }
    public static int getPingInterval(Configuration p0){ return 0; }
    public static int getRpcTimeout(Configuration p0){ return 0; }
    public static int getTimeout(Configuration p0){ return 0; }
    public static int nextCallId(){ return 0; }
    public static void setAsynchronousMode(boolean p0){}
    public static void setCallIdAndRetryCount(int p0, int p1, Object p2){}
    public static void setConnectTimeout(Configuration p0, int p1){}
    public static void setPingInterval(Configuration p0, int p1){}
    public void close(){}
    public void stop(){}
    static public class ConnectionId
    {
        protected ConnectionId() {}
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int getMaxRetriesOnSasl(){ return 0; }
        public int getMaxRetriesOnSocketTimeouts(){ return 0; }
        public int hashCode(){ return 0; }
    }
}
