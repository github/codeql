// Generated automatically from android.net.http.SslCertificate for testing purposes

package android.net.http;

import android.os.Bundle;
import java.security.cert.X509Certificate;
import java.util.Date;

public class SslCertificate
{
    protected SslCertificate() {}
    public Date getValidNotAfterDate(){ return null; }
    public Date getValidNotBeforeDate(){ return null; }
    public SslCertificate(String p0, String p1, Date p2, Date p3){}
    public SslCertificate(String p0, String p1, String p2, String p3){}
    public SslCertificate(X509Certificate p0){}
    public SslCertificate.DName getIssuedBy(){ return null; }
    public SslCertificate.DName getIssuedTo(){ return null; }
    public String getValidNotAfter(){ return null; }
    public String getValidNotBefore(){ return null; }
    public String toString(){ return null; }
    public X509Certificate getX509Certificate(){ return null; }
    public class DName
    {
        protected DName() {}
        public DName(String p0){}
        public String getCName(){ return null; }
        public String getDName(){ return null; }
        public String getOName(){ return null; }
        public String getUName(){ return null; }
    }
    public static Bundle saveState(SslCertificate p0){ return null; }
    public static SslCertificate restoreState(Bundle p0){ return null; }
}
