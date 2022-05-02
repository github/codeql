// Generated automatically from okhttp3.internal.tls.CertificateChainCleaner for testing purposes

package okhttp3.internal.tls;

import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.List;
import javax.net.ssl.X509TrustManager;

abstract public class CertificateChainCleaner
{
    public CertificateChainCleaner(){}
    public abstract List<Certificate> clean(List<? extends Certificate> p0, String p1);
    public static CertificateChainCleaner.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final CertificateChainCleaner get(X509Certificate... p0){ return null; }
        public final CertificateChainCleaner get(X509TrustManager p0){ return null; }
    }
}
