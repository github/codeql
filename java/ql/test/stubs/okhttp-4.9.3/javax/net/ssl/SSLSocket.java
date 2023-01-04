// Generated automatically from javax.net.ssl.SSLSocket for testing purposes

package javax.net.ssl;

import java.net.InetAddress;
import java.net.Socket;
import java.util.List;
import java.util.function.BiFunction;
import javax.net.ssl.HandshakeCompletedListener;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLSession;

abstract public class SSLSocket extends Socket
{
    protected SSLSocket(){}
    protected SSLSocket(InetAddress p0, int p1){}
    protected SSLSocket(InetAddress p0, int p1, InetAddress p2, int p3){}
    protected SSLSocket(String p0, int p1){}
    protected SSLSocket(String p0, int p1, InetAddress p2, int p3){}
    public BiFunction<SSLSocket, List<String>, String> getHandshakeApplicationProtocolSelector(){ return null; }
    public SSLParameters getSSLParameters(){ return null; }
    public SSLSession getHandshakeSession(){ return null; }
    public String getApplicationProtocol(){ return null; }
    public String getHandshakeApplicationProtocol(){ return null; }
    public abstract SSLSession getSession();
    public abstract String[] getEnabledCipherSuites();
    public abstract String[] getEnabledProtocols();
    public abstract String[] getSupportedCipherSuites();
    public abstract String[] getSupportedProtocols();
    public abstract boolean getEnableSessionCreation();
    public abstract boolean getNeedClientAuth();
    public abstract boolean getUseClientMode();
    public abstract boolean getWantClientAuth();
    public abstract void addHandshakeCompletedListener(HandshakeCompletedListener p0);
    public abstract void removeHandshakeCompletedListener(HandshakeCompletedListener p0);
    public abstract void setEnableSessionCreation(boolean p0);
    public abstract void setEnabledCipherSuites(String[] p0);
    public abstract void setEnabledProtocols(String[] p0);
    public abstract void setNeedClientAuth(boolean p0);
    public abstract void setUseClientMode(boolean p0);
    public abstract void setWantClientAuth(boolean p0);
    public abstract void startHandshake();
    public void setHandshakeApplicationProtocolSelector(BiFunction<SSLSocket, List<String>, String> p0){}
    public void setSSLParameters(SSLParameters p0){}
}
