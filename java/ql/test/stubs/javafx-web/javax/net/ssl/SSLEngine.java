// Generated automatically from javax.net.ssl.SSLEngine for testing purposes

package javax.net.ssl;

import java.nio.ByteBuffer;
import java.util.List;
import java.util.function.BiFunction;
import javax.net.ssl.SSLEngineResult;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLSession;

abstract public class SSLEngine
{
    protected SSLEngine(){}
    protected SSLEngine(String p0, int p1){}
    public BiFunction<SSLEngine, List<String>, String> getHandshakeApplicationProtocolSelector(){ return null; }
    public SSLEngineResult unwrap(ByteBuffer p0, ByteBuffer p1){ return null; }
    public SSLEngineResult unwrap(ByteBuffer p0, ByteBuffer[] p1){ return null; }
    public SSLEngineResult wrap(ByteBuffer p0, ByteBuffer p1){ return null; }
    public SSLEngineResult wrap(ByteBuffer[] p0, ByteBuffer p1){ return null; }
    public SSLParameters getSSLParameters(){ return null; }
    public SSLSession getHandshakeSession(){ return null; }
    public String getApplicationProtocol(){ return null; }
    public String getHandshakeApplicationProtocol(){ return null; }
    public String getPeerHost(){ return null; }
    public abstract Runnable getDelegatedTask();
    public abstract SSLEngineResult unwrap(ByteBuffer p0, ByteBuffer[] p1, int p2, int p3);
    public abstract SSLEngineResult wrap(ByteBuffer[] p0, int p1, int p2, ByteBuffer p3);
    public abstract SSLEngineResult.HandshakeStatus getHandshakeStatus();
    public abstract SSLSession getSession();
    public abstract String[] getEnabledCipherSuites();
    public abstract String[] getEnabledProtocols();
    public abstract String[] getSupportedCipherSuites();
    public abstract String[] getSupportedProtocols();
    public abstract boolean getEnableSessionCreation();
    public abstract boolean getNeedClientAuth();
    public abstract boolean getUseClientMode();
    public abstract boolean getWantClientAuth();
    public abstract boolean isInboundDone();
    public abstract boolean isOutboundDone();
    public abstract void beginHandshake();
    public abstract void closeInbound();
    public abstract void closeOutbound();
    public abstract void setEnableSessionCreation(boolean p0);
    public abstract void setEnabledCipherSuites(String[] p0);
    public abstract void setEnabledProtocols(String[] p0);
    public abstract void setNeedClientAuth(boolean p0);
    public abstract void setUseClientMode(boolean p0);
    public abstract void setWantClientAuth(boolean p0);
    public int getPeerPort(){ return 0; }
    public void setHandshakeApplicationProtocolSelector(BiFunction<SSLEngine, List<String>, String> p0){}
    public void setSSLParameters(SSLParameters p0){}
}
