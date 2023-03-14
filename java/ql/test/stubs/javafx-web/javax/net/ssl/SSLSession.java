// Generated automatically from javax.net.ssl.SSLSession for testing purposes

package javax.net.ssl;

import java.security.Principal;
import java.security.cert.Certificate;
import javax.net.ssl.SSLSessionContext;
import javax.security.cert.X509Certificate;

public interface SSLSession
{
    Certificate[] getLocalCertificates();
    Certificate[] getPeerCertificates();
    Object getValue(String p0);
    Principal getLocalPrincipal();
    Principal getPeerPrincipal();
    SSLSessionContext getSessionContext();
    String getCipherSuite();
    String getPeerHost();
    String getProtocol();
    String[] getValueNames();
    boolean isValid();
    byte[] getId();
    default X509Certificate[] getPeerCertificateChain(){ return null; }
    int getApplicationBufferSize();
    int getPacketBufferSize();
    int getPeerPort();
    long getCreationTime();
    long getLastAccessedTime();
    void invalidate();
    void putValue(String p0, Object p1);
    void removeValue(String p0);
}
