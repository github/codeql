// Generated automatically from okhttp3.Handshake for testing purposes

package okhttp3;

import java.security.Principal;
import java.security.cert.Certificate;
import java.util.List;
import javax.net.ssl.SSLSession;
import kotlin.jvm.functions.Function0;
import okhttp3.CipherSuite;
import okhttp3.TlsVersion;

public class Handshake
{
    protected Handshake() {}
    public Handshake(TlsVersion p0, CipherSuite p1, List<? extends Certificate> p2, Function0<? extends List<? extends Certificate>> p3){}
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public final CipherSuite cipherSuite(){ return null; }
    public final List<Certificate> localCertificates(){ return null; }
    public final List<Certificate> peerCertificates(){ return null; }
    public final Principal localPrincipal(){ return null; }
    public final Principal peerPrincipal(){ return null; }
    public final TlsVersion tlsVersion(){ return null; }
    public int hashCode(){ return 0; }
    public static Handshake get(SSLSession p0){ return null; }
    public static Handshake get(TlsVersion p0, CipherSuite p1, List<? extends Certificate> p2, List<? extends Certificate> p3){ return null; }
    public static Handshake.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final Handshake get(SSLSession p0){ return null; }
        public final Handshake get(TlsVersion p0, CipherSuite p1, List<? extends Certificate> p2, List<? extends Certificate> p3){ return null; }
    }
}
