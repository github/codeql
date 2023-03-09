// Generated automatically from org.apache.hadoop.ipc.RPC for testing purposes

package org.apache.hadoop.ipc;

import java.net.InetSocketAddress;
import java.util.concurrent.atomic.AtomicBoolean;
import javax.net.SocketFactory;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.retry.RetryPolicy;
import org.apache.hadoop.ipc.Client;
import org.apache.hadoop.ipc.ProtocolProxy;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hadoop.security.token.SecretManager;
import org.apache.hadoop.security.token.TokenIdentifier;

public class RPC
{
    public class RpcInvoker {}
    protected RPC() {}
    abstract static public class Server extends org.apache.hadoop.ipc.Server
    {
        protected Server() {}
        protected Server(String p0, int p1, Class<? extends Writable> p2, int p3, int p4, int p5, Configuration p6, String p7, SecretManager<? extends TokenIdentifier> p8, String p9){}
        public RPC.Server addProtocol(RPC.RpcKind p0, Class<? extends Object> p1, Object p2){ return null; }
        public Writable call(RPC.RpcKind p0, String p1, Writable p2, long p3){ return null; }
    }
    public static <T> T getProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3){ return null; }
    public static <T> T getProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3, SocketFactory p4){ return null; }
    public static <T> T getProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, UserGroupInformation p3, Configuration p4, SocketFactory p5){ return null; }
    public static <T> T getProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, UserGroupInformation p3, Configuration p4, SocketFactory p5, int p6){ return null; }
    public static <T> T waitForProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3){ return null; }
    public static <T> T waitForProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3, int p4, long p5){ return null; }
    public static <T> T waitForProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3, long p4){ return null; }
    public static <T> org.apache.hadoop.ipc.ProtocolProxy<T> getProtocolProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3){ return null; }
    public static <T> org.apache.hadoop.ipc.ProtocolProxy<T> getProtocolProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3, SocketFactory p4){ return null; }
    public static <T> org.apache.hadoop.ipc.ProtocolProxy<T> getProtocolProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, UserGroupInformation p3, Configuration p4, SocketFactory p5){ return null; }
    public static <T> org.apache.hadoop.ipc.ProtocolProxy<T> getProtocolProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, UserGroupInformation p3, Configuration p4, SocketFactory p5, int p6, RetryPolicy p7){ return null; }
    public static <T> org.apache.hadoop.ipc.ProtocolProxy<T> getProtocolProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, UserGroupInformation p3, Configuration p4, SocketFactory p5, int p6, RetryPolicy p7, AtomicBoolean p8){ return null; }
    public static <T> org.apache.hadoop.ipc.ProtocolProxy<T> waitForProtocolProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3){ return null; }
    public static <T> org.apache.hadoop.ipc.ProtocolProxy<T> waitForProtocolProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3, int p4, RetryPolicy p5, long p6){ return null; }
    public static <T> org.apache.hadoop.ipc.ProtocolProxy<T> waitForProtocolProxy(java.lang.Class<T> p0, long p1, InetSocketAddress p2, Configuration p3, long p4){ return null; }
    public static Client.ConnectionId getConnectionIdForProxy(Object p0){ return null; }
    public static InetSocketAddress getServerAddress(Object p0){ return null; }
    public static String getProtocolName(Class<? extends Object> p0){ return null; }
    public static int getRpcTimeout(Configuration p0){ return 0; }
    public static long getProtocolVersion(Class<? extends Object> p0){ return 0; }
    public static void setProtocolEngine(Configuration p0, Class<? extends Object> p1, Class<? extends Object> p2){}
    public static void stopProxy(Object p0){}
    static public enum RpcKind
    {
        RPC_BUILTIN, RPC_PROTOCOL_BUFFER, RPC_WRITABLE;
        private RpcKind() {}
    }
}
