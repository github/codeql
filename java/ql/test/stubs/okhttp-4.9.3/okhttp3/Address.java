// Generated automatically from okhttp3.Address for testing purposes

package okhttp3;

import java.net.Proxy;
import java.net.ProxySelector;
import java.util.List;
import javax.net.SocketFactory;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSocketFactory;
import okhttp3.Authenticator;
import okhttp3.CertificatePinner;
import okhttp3.ConnectionSpec;
import okhttp3.Dns;
import okhttp3.HttpUrl;
import okhttp3.Protocol;

public class Address
{
    protected Address() {}
    public Address(String p0, int p1, Dns p2, SocketFactory p3, SSLSocketFactory p4, HostnameVerifier p5, CertificatePinner p6, Authenticator p7, Proxy p8, List<? extends Protocol> p9, List<ConnectionSpec> p10, ProxySelector p11){}
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public final Authenticator proxyAuthenticator(){ return null; }
    public final CertificatePinner certificatePinner(){ return null; }
    public final Dns dns(){ return null; }
    public final HostnameVerifier hostnameVerifier(){ return null; }
    public final HttpUrl url(){ return null; }
    public final List<ConnectionSpec> connectionSpecs(){ return null; }
    public final List<Protocol> protocols(){ return null; }
    public final Proxy proxy(){ return null; }
    public final ProxySelector proxySelector(){ return null; }
    public final SSLSocketFactory sslSocketFactory(){ return null; }
    public final SocketFactory socketFactory(){ return null; }
    public final boolean equalsNonHost$okhttp(Address p0){ return false; }
    public int hashCode(){ return 0; }
}
