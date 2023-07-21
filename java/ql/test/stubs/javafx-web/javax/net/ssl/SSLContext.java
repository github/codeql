// Generated automatically from javax.net.ssl.SSLContext for testing purposes

package javax.net.ssl;

import java.security.Provider;
import java.security.SecureRandom;
import javax.net.ssl.KeyManager;
import javax.net.ssl.SSLContextSpi;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLServerSocketFactory;
import javax.net.ssl.SSLSessionContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;

public class SSLContext
{
    protected SSLContext() {}
    protected SSLContext(SSLContextSpi p0, Provider p1, String p2){}
    public final Provider getProvider(){ return null; }
    public final SSLEngine createSSLEngine(){ return null; }
    public final SSLEngine createSSLEngine(String p0, int p1){ return null; }
    public final SSLParameters getDefaultSSLParameters(){ return null; }
    public final SSLParameters getSupportedSSLParameters(){ return null; }
    public final SSLServerSocketFactory getServerSocketFactory(){ return null; }
    public final SSLSessionContext getClientSessionContext(){ return null; }
    public final SSLSessionContext getServerSessionContext(){ return null; }
    public final SSLSocketFactory getSocketFactory(){ return null; }
    public final String getProtocol(){ return null; }
    public final void init(KeyManager[] p0, TrustManager[] p1, SecureRandom p2){}
    public static SSLContext getDefault(){ return null; }
    public static SSLContext getInstance(String p0){ return null; }
    public static SSLContext getInstance(String p0, Provider p1){ return null; }
    public static SSLContext getInstance(String p0, String p1){ return null; }
    public static void setDefault(SSLContext p0){}
}
