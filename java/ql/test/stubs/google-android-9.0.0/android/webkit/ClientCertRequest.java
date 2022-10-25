// Generated automatically from android.webkit.ClientCertRequest for testing purposes

package android.webkit;

import java.security.Principal;
import java.security.PrivateKey;
import java.security.cert.X509Certificate;

abstract public class ClientCertRequest
{
    public ClientCertRequest(){}
    public abstract Principal[] getPrincipals();
    public abstract String getHost();
    public abstract String[] getKeyTypes();
    public abstract int getPort();
    public abstract void cancel();
    public abstract void ignore();
    public abstract void proceed(PrivateKey p0, X509Certificate[] p1);
}
