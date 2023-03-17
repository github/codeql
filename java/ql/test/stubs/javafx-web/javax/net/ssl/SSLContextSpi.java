// Generated automatically from javax.net.ssl.SSLContextSpi for testing purposes

package javax.net.ssl;

import java.security.SecureRandom;
import javax.net.ssl.KeyManager;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLServerSocketFactory;
import javax.net.ssl.SSLSessionContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;

abstract public class SSLContextSpi
{
    protected SSLParameters engineGetDefaultSSLParameters(){ return null; }
    protected SSLParameters engineGetSupportedSSLParameters(){ return null; }
    protected abstract SSLEngine engineCreateSSLEngine();
    protected abstract SSLEngine engineCreateSSLEngine(String p0, int p1);
    protected abstract SSLServerSocketFactory engineGetServerSocketFactory();
    protected abstract SSLSessionContext engineGetClientSessionContext();
    protected abstract SSLSessionContext engineGetServerSessionContext();
    protected abstract SSLSocketFactory engineGetSocketFactory();
    protected abstract void engineInit(KeyManager[] p0, TrustManager[] p1, SecureRandom p2);
    public SSLContextSpi(){}
}
