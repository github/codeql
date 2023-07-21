// Generated automatically from javax.net.ssl.SSLServerSocketFactory for testing purposes

package javax.net.ssl;

import javax.net.ServerSocketFactory;

abstract public class SSLServerSocketFactory extends ServerSocketFactory
{
    protected SSLServerSocketFactory(){}
    public abstract String[] getDefaultCipherSuites();
    public abstract String[] getSupportedCipherSuites();
    public static ServerSocketFactory getDefault(){ return null; }
}
