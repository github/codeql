// Generated automatically from javax.net.ServerSocketFactory for testing purposes

package javax.net;

import java.net.InetAddress;
import java.net.ServerSocket;

abstract public class ServerSocketFactory
{
    protected ServerSocketFactory(){}
    public ServerSocket createServerSocket(){ return null; }
    public abstract ServerSocket createServerSocket(int p0);
    public abstract ServerSocket createServerSocket(int p0, int p1);
    public abstract ServerSocket createServerSocket(int p0, int p1, InetAddress p2);
    public static ServerSocketFactory getDefault(){ return null; }
}
