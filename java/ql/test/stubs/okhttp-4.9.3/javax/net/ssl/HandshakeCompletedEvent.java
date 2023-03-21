// Generated automatically from javax.net.ssl.HandshakeCompletedEvent for testing purposes

package javax.net.ssl;

import java.security.Principal;
import java.security.cert.Certificate;
import java.util.EventObject;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import javax.security.cert.X509Certificate;

public class HandshakeCompletedEvent extends EventObject
{
    protected HandshakeCompletedEvent() { super(null); } // manually corrected
    public Certificate[] getLocalCertificates(){ return null; }
    public Certificate[] getPeerCertificates(){ return null; }
    public HandshakeCompletedEvent(SSLSocket p0, SSLSession p1){ super(null); } // manually corrected
    public Principal getLocalPrincipal(){ return null; }
    public Principal getPeerPrincipal(){ return null; }
    public SSLSession getSession(){ return null; }
    public SSLSocket getSocket(){ return null; }
    public String getCipherSuite(){ return null; }
    public X509Certificate[] getPeerCertificateChain(){ return null; }
}
