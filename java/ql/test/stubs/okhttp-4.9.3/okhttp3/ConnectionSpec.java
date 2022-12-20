// Generated automatically from okhttp3.ConnectionSpec for testing purposes

package okhttp3;

import java.util.List;
import javax.net.ssl.SSLSocket;
import okhttp3.CipherSuite;
import okhttp3.TlsVersion;

public class ConnectionSpec
{
    protected ConnectionSpec() {}
    public ConnectionSpec(boolean p0, boolean p1, String[] p2, String[] p3){}
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public final List<CipherSuite> cipherSuites(){ return null; }
    public final List<TlsVersion> tlsVersions(){ return null; }
    public final boolean isCompatible(SSLSocket p0){ return false; }
    public final boolean isTls(){ return false; }
    public final boolean supportsTlsExtensions(){ return false; }
    public final void apply$okhttp(SSLSocket p0, boolean p1){}
    public int hashCode(){ return 0; }
    public static ConnectionSpec CLEARTEXT = null;
    public static ConnectionSpec COMPATIBLE_TLS = null;
    public static ConnectionSpec MODERN_TLS = null;
    public static ConnectionSpec RESTRICTED_TLS = null;
    public static ConnectionSpec.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
    }
}
