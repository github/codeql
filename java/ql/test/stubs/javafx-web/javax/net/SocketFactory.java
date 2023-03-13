// Generated automatically from javax.net.SocketFactory for testing purposes

package javax.net;

import java.net.InetAddress;
import java.net.Socket;

abstract public class SocketFactory
{
    protected SocketFactory(){}
    public Socket createSocket(){ return null; }
    public abstract Socket createSocket(InetAddress p0, int p1);
    public abstract Socket createSocket(InetAddress p0, int p1, InetAddress p2, int p3);
    public abstract Socket createSocket(String p0, int p1);
    public abstract Socket createSocket(String p0, int p1, InetAddress p2, int p3);
    public static SocketFactory getDefault(){ return null; }
}
