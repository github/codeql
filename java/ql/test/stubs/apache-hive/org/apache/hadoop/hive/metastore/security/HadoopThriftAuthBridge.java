// Generated automatically from org.apache.hadoop.hive.metastore.security.HadoopThriftAuthBridge for testing purposes

package org.apache.hadoop.hive.metastore.security;

import java.net.InetAddress;
import java.util.Map;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hive.metastore.security.DelegationTokenSecretManager;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.thrift.TProcessor;
import org.apache.thrift.transport.TSaslServerTransport;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportFactory;

abstract public class HadoopThriftAuthBridge
{
    public HadoopThriftAuthBridge(){}
    public HadoopThriftAuthBridge.Client createClient(){ return null; }
    public HadoopThriftAuthBridge.Client createClientWithConf(String p0){ return null; }
    public HadoopThriftAuthBridge.Server createServer(String p0, String p1, String p2){ return null; }
    public String getCanonicalHostName(String p0){ return null; }
    public String getServerPrincipal(String p0, String p1){ return null; }
    public UserGroupInformation getCurrentUGIWithConf(String p0){ return null; }
    public abstract Map<String, String> getHadoopSaslProperties(Configuration p0);
    public static HadoopThriftAuthBridge getBridge(){ return null; }
    static public class Client
    {
        public Client(){}
        public TTransport createClientTransport(String p0, String p1, String p2, String p3, TTransport p4, Map<String, String> p5){ return null; }
    }
    static public class Server
    {
        protected DelegationTokenSecretManager secretManager = null;
        protected Server(String p0, String p1, String p2){}
        protected final UserGroupInformation clientValidationUGI = null;
        protected final UserGroupInformation realUgi = null;
        public InetAddress getRemoteAddress(){ return null; }
        public Server(){}
        public String getRemoteUser(){ return null; }
        public String getUserAuthMechanism(){ return null; }
        public TProcessor wrapNonAssumingProcessor(TProcessor p0){ return null; }
        public TProcessor wrapProcessor(TProcessor p0){ return null; }
        public TSaslServerTransport.Factory createSaslServerTransportFactory(Map<String, String> p0){ return null; }
        public TTransportFactory createTransportFactory(Map<String, String> p0){ return null; }
        public TTransportFactory wrapTransportFactory(TTransportFactory p0){ return null; }
        public void setSecretManager(DelegationTokenSecretManager p0){}
    }
}
