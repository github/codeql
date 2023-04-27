// Generated automatically from javax.security.cert.X509Certificate for testing purposes

package javax.security.cert;

import java.io.InputStream;
import java.math.BigInteger;
import java.security.Principal;
import java.util.Date;
import javax.security.cert.Certificate;

abstract public class X509Certificate extends Certificate
{
    public X509Certificate(){}
    public abstract BigInteger getSerialNumber();
    public abstract Date getNotAfter();
    public abstract Date getNotBefore();
    public abstract Principal getIssuerDN();
    public abstract Principal getSubjectDN();
    public abstract String getSigAlgName();
    public abstract String getSigAlgOID();
    public abstract byte[] getSigAlgParams();
    public abstract int getVersion();
    public abstract void checkValidity();
    public abstract void checkValidity(Date p0);
    public static X509Certificate getInstance(InputStream p0){ return null; }
    public static X509Certificate getInstance(byte[] p0){ return null; }
}
