// Generated automatically from okhttp3.CertificatePinner for testing purposes

package okhttp3;

import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.List;
import java.util.Set;
import kotlin.jvm.functions.Function0;
import okhttp3.internal.tls.CertificateChainCleaner;
import okio.ByteString;

public class CertificatePinner
{
    protected CertificatePinner() {}
    public CertificatePinner(Set<CertificatePinner.Pin> p0, CertificateChainCleaner p1){}
    public boolean equals(Object p0){ return false; }
    public final CertificateChainCleaner getCertificateChainCleaner$okhttp(){ return null; }
    public final CertificatePinner withCertificateChainCleaner$okhttp(CertificateChainCleaner p0){ return null; }
    public final List<CertificatePinner.Pin> findMatchingPins(String p0){ return null; }
    public final Set<CertificatePinner.Pin> getPins(){ return null; }
    public final void check$okhttp(String p0, Function0<? extends List<? extends X509Certificate>> p1){}
    public final void check(String p0, Certificate... p1){}
    public final void check(String p0, List<? extends Certificate> p1){}
    public int hashCode(){ return 0; }
    public static ByteString sha1Hash(X509Certificate p0){ return null; }
    public static ByteString sha256Hash(X509Certificate p0){ return null; }
    public static CertificatePinner DEFAULT = null;
    public static CertificatePinner.Companion Companion = null;
    public static String pin(Certificate p0){ return null; }
    static public class Builder
    {
        public Builder(){}
        public final CertificatePinner build(){ return null; }
        public final CertificatePinner.Builder add(String p0, String... p1){ return null; }
        public final List<CertificatePinner.Pin> getPins(){ return null; }
    }
    static public class Companion
    {
        protected Companion() {}
        public final ByteString sha1Hash(X509Certificate p0){ return null; }
        public final ByteString sha256Hash(X509Certificate p0){ return null; }
        public final String pin(Certificate p0){ return null; }
    }
    static public class Pin
    {
        protected Pin() {}
        public Pin(String p0, String p1){}
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public final ByteString getHash(){ return null; }
        public final String getHashAlgorithm(){ return null; }
        public final String getPattern(){ return null; }
        public final boolean matchesCertificate(X509Certificate p0){ return false; }
        public final boolean matchesHostname(String p0){ return false; }
        public int hashCode(){ return 0; }
    }
}
