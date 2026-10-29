// Generated automatically from org.apache.hadoop.ipc.Server for testing purposes

package org.apache.hadoop.ipc;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.nio.channels.SocketChannel;
import java.security.PrivilegedExceptionAction;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.ipc.RPC;
import org.apache.hadoop.ipc.Schedulable;
import org.apache.hadoop.ipc.metrics.RpcDetailedMetrics;
import org.apache.hadoop.ipc.metrics.RpcMetrics;
import org.apache.hadoop.ipc.protobuf.RpcHeaderProtos;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hadoop.security.authorize.PolicyProvider;
import org.apache.hadoop.security.authorize.ServiceAuthorizationManager;
import org.apache.hadoop.security.token.SecretManager;
import org.apache.hadoop.security.token.TokenIdentifier;
import org.apache.htrace.core.Tracer;
import org.slf4j.Logger;

abstract public class Server
{
    protected Server() {}
    protected Server(String p0, int p1, Class<? extends Writable> p2, int p3, Configuration p4){}
    protected Server(String p0, int p1, Class<? extends Writable> p2, int p3, int p4, int p5, Configuration p6, String p7, SecretManager<? extends TokenIdentifier> p8){}
    protected Server(String p0, int p1, Class<? extends Writable> p2, int p3, int p4, int p5, Configuration p6, String p7, SecretManager<? extends TokenIdentifier> p8, String p9){}
    protected boolean isLogSlowRPC(){ return false; }
    protected final RpcDetailedMetrics rpcDetailedMetrics = null;
    protected final RpcMetrics rpcMetrics = null;
    protected void setLogSlowRPC(boolean p0){}
    public Class<? extends Writable> getRpcRequestWrapper(RpcHeaderProtos.RpcKindProto p0){ return null; }
    public InetSocketAddress getListenerAddress(){ return null; }
    public RpcDetailedMetrics getRpcDetailedMetrics(){ return null; }
    public RpcMetrics getRpcMetrics(){ return null; }
    public ServiceAuthorizationManager getServiceAuthorizationManager(){ return null; }
    public String getNumOpenConnectionsPerUser(){ return null; }
    public Writable call(Writable p0, long p1){ return null; }
    public abstract Writable call(RPC.RpcKind p0, String p1, Writable p2, long p3);
    public boolean isClientBackoffEnabled(){ return false; }
    public class Connection
    {
        protected Connection() {}
        public Connection(SocketChannel p0, long p1){}
        public InetAddress getHostInetAddress(){ return null; }
        public String getHostAddress(){ return null; }
        public String toString(){ return null; }
        public UserGroupInformation attemptingUser = null;
        public int getServiceClass(){ return 0; }
        public int readAndProcess(){ return 0; }
        public long getLastContact(){ return 0; }
        public org.apache.hadoop.ipc.Server getServer(){ return null; }
        public void setLastContact(long p0){}
        public void setServiceClass(int p0){}
    }
    public int getCallQueueLen(){ return 0; }
    public int getMaxQueueSize(){ return 0; }
    public int getNumOpenConnections(){ return 0; }
    public int getNumReaders(){ return 0; }
    public int getPort(){ return 0; }
    public long getNumDroppedConnections(){ return 0; }
    public static InetAddress getRemoteIp(){ return null; }
    public static Logger AUDITLOG = null;
    public static Logger LOG = null;
    public static RPC.RpcInvoker getRpcInvoker(RPC.RpcKind p0){ return null; }
    public static String getProtocol(){ return null; }
    public static String getRemoteAddress(){ return null; }
    public static ThreadLocal<org.apache.hadoop.ipc.Server.Call> getCurCall(){ return null; }
    public static UserGroupInformation getRemoteUser(){ return null; }
    public static boolean isRpcInvocation(){ return false; }
    public static byte[] getClientId(){ return null; }
    public static int getCallId(){ return 0; }
    public static int getCallRetryCount(){ return 0; }
    public static int getPriorityLevel(){ return 0; }
    public static org.apache.hadoop.ipc.Server get(){ return null; }
    public static void bind(ServerSocket p0, InetSocketAddress p1, int p2){}
    public static void bind(ServerSocket p0, InetSocketAddress p1, int p2, Configuration p3, String p4){}
    public static void registerProtocolEngine(RPC.RpcKind p0, Class<? extends Writable> p1, RPC.RpcInvoker p2){}
    public void addSuppressedLoggingExceptions(Class<? extends Object>... p0){}
    public void addTerseExceptions(Class<? extends Object>... p0){}
    public void join(){}
    public void queueCall(org.apache.hadoop.ipc.Server.Call p0){}
    public void refreshCallQueue(Configuration p0){}
    public void refreshServiceAcl(Configuration p0, PolicyProvider p1){}
    public void refreshServiceAclWithLoadedConfiguration(Configuration p0, PolicyProvider p1){}
    public void setClientBackoffEnabled(boolean p0){}
    public void setSocketSendBufSize(int p0){}
    public void setTracer(Tracer p0){}
    public void start(){}
    public void stop(){}
    static public class Call implements PrivilegedExceptionAction<Void>, Schedulable
    {
        public Call(int p0, int p1, Void p2, Void p3, RPC.RpcKind p4, byte[] p5){}
        public InetAddress getHostInetAddress(){ return null; }
        public String getHostAddress(){ return null; }
        public String getProtocol(){ return null; }
        public String toString(){ return null; }
        public UserGroupInformation getRemoteUser(){ return null; }
        public UserGroupInformation getUserGroupInformation(){ return null; }
        public Void run(){ return null; }
        public boolean isResponseDeferred(){ return false; }
        public final void abortResponse(Throwable p0){}
        public final void postponeResponse(){}
        public final void sendResponse(){}
        public int getPriorityLevel(){ return 0; }
        public void deferResponse(){}
        public void setDeferredError(Throwable p0){}
        public void setDeferredResponse(Writable p0){}
        public void setPriorityLevel(int p0){}
    }
}
