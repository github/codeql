// Generated automatically from org.apache.hadoop.security.SaslRpcServer for testing purposes

package org.apache.hadoop.security;

import java.io.DataInput;
import java.io.DataOutput;
import java.util.Map;
import javax.security.sasl.SaslServer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.security.token.SecretManager;
import org.apache.hadoop.security.token.TokenIdentifier;
import org.slf4j.Logger;

public class SaslRpcServer
{
    protected SaslRpcServer() {}
    public SaslRpcServer(SaslRpcServer.AuthMethod p0){}
    public SaslRpcServer.AuthMethod authMethod = null;
    public SaslServer create(org.apache.hadoop.ipc.Server.Connection p0, Map<String, ? extends Object> p1, SecretManager<TokenIdentifier> p2){ return null; }
    public String mechanism = null;
    public String protocol = null;
    public String serverId = null;
    public static <T extends TokenIdentifier> T getIdentifier(String p0, org.apache.hadoop.security.token.SecretManager<T> p1){ return null; }
    public static Logger LOG = null;
    public static String SASL_DEFAULT_REALM = null;
    public static String[] splitKerberosName(String p0){ return null; }
    public static void init(Configuration p0){}
    static public enum AuthMethod
    {
        DIGEST, KERBEROS, PLAIN, SIMPLE, TOKEN;
        private AuthMethod() {}
        public String getMechanismName(){ return null; }
        public final String mechanismName = null;
        public final byte code = 0;
        public static SaslRpcServer.AuthMethod read(DataInput p0){ return null; }
        public void write(DataOutput p0){}
    }
}
