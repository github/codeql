// Generated automatically from javax.net.ssl.SSLSessionContext for testing purposes

package javax.net.ssl;

import java.util.Enumeration;
import javax.net.ssl.SSLSession;

public interface SSLSessionContext
{
    Enumeration<byte[]> getIds();
    SSLSession getSession(byte[] p0);
    int getSessionCacheSize();
    int getSessionTimeout();
    void setSessionCacheSize(int p0);
    void setSessionTimeout(int p0);
}
