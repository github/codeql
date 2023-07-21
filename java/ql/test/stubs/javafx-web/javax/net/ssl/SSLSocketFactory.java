// Generated automatically from javax.net.ssl.SSLSocketFactory for testing purposes

package javax.net.ssl;

import java.io.InputStream;
import java.net.Socket;
import javax.net.SocketFactory;

abstract public class SSLSocketFactory extends SocketFactory
{
    public SSLSocketFactory(){}
    public Socket createSocket(Socket p0, InputStream p1, boolean p2){ return null; }
    public abstract Socket createSocket(Socket p0, String p1, int p2, boolean p3);
    public abstract String[] getDefaultCipherSuites();
    public abstract String[] getSupportedCipherSuites();
    public static SocketFactory getDefault(){ return null; }
}
