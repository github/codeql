// Generated automatically from javax.net.ssl.X509TrustManager for testing purposes

package javax.net.ssl;

import java.security.cert.X509Certificate;
import javax.net.ssl.TrustManager;

public interface X509TrustManager extends TrustManager
{
    X509Certificate[] getAcceptedIssuers();
    void checkClientTrusted(X509Certificate[] p0, String p1);
    void checkServerTrusted(X509Certificate[] p0, String p1);
}
