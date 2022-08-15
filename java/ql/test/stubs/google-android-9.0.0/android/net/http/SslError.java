// Generated automatically from android.net.http.SslError for testing purposes

package android.net.http;

import android.net.http.SslCertificate;
import java.security.cert.X509Certificate;

public class SslError
{
    protected SslError() {}
    public SslCertificate getCertificate(){ return null; }
    public SslError(int p0, SslCertificate p1){}
    public SslError(int p0, SslCertificate p1, String p2){}
    public SslError(int p0, X509Certificate p1){}
    public SslError(int p0, X509Certificate p1, String p2){}
    public String getUrl(){ return null; }
    public String toString(){ return null; }
    public boolean addError(int p0){ return false; }
    public boolean hasError(int p0){ return false; }
    public int getPrimaryError(){ return 0; }
    public static int SSL_DATE_INVALID = 0;
    public static int SSL_EXPIRED = 0;
    public static int SSL_IDMISMATCH = 0;
    public static int SSL_INVALID = 0;
    public static int SSL_MAX_ERROR = 0;
    public static int SSL_NOTYETVALID = 0;
    public static int SSL_UNTRUSTED = 0;
}
