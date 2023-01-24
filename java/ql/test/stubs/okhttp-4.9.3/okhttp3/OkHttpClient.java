// Generated automatically from okhttp3.OkHttpClient for testing purposes

package okhttp3;

import java.net.Proxy;
import java.net.ProxySelector;
import java.time.Duration;
import java.util.List;
import java.util.concurrent.TimeUnit;
import javax.net.SocketFactory;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.X509TrustManager;
import okhttp3.Authenticator;
import okhttp3.Cache;
import okhttp3.Call;
import okhttp3.CertificatePinner;
import okhttp3.ConnectionPool;
import okhttp3.ConnectionSpec;
import okhttp3.CookieJar;
import okhttp3.Dispatcher;
import okhttp3.Dns;
import okhttp3.EventListener;
import okhttp3.Interceptor;
import okhttp3.Protocol;
import okhttp3.Request;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;
import okhttp3.internal.connection.RouteDatabase;
import okhttp3.internal.tls.CertificateChainCleaner;

public class OkHttpClient implements Call.Factory, Cloneable, WebSocket.Factory
{
    public Call newCall(Request p0){ return null; }
    public Object clone(){ return null; }
    public OkHttpClient(){}
    public OkHttpClient(OkHttpClient.Builder p0){}
    public OkHttpClient.Builder newBuilder(){ return null; }
    public WebSocket newWebSocket(Request p0, WebSocketListener p1){ return null; }
    public final Authenticator authenticator(){ return null; }
    public final Authenticator proxyAuthenticator(){ return null; }
    public final Cache cache(){ return null; }
    public final CertificateChainCleaner certificateChainCleaner(){ return null; }
    public final CertificatePinner certificatePinner(){ return null; }
    public final ConnectionPool connectionPool(){ return null; }
    public final CookieJar cookieJar(){ return null; }
    public final Dispatcher dispatcher(){ return null; }
    public final Dns dns(){ return null; }
    public final EventListener.Factory eventListenerFactory(){ return null; }
    public final HostnameVerifier hostnameVerifier(){ return null; }
    public final List<ConnectionSpec> connectionSpecs(){ return null; }
    public final List<Interceptor> interceptors(){ return null; }
    public final List<Interceptor> networkInterceptors(){ return null; }
    public final List<Protocol> protocols(){ return null; }
    public final Proxy proxy(){ return null; }
    public final ProxySelector proxySelector(){ return null; }
    public final RouteDatabase getRouteDatabase(){ return null; }
    public final SSLSocketFactory sslSocketFactory(){ return null; }
    public final SocketFactory socketFactory(){ return null; }
    public final X509TrustManager x509TrustManager(){ return null; }
    public final boolean followRedirects(){ return false; }
    public final boolean followSslRedirects(){ return false; }
    public final boolean retryOnConnectionFailure(){ return false; }
    public final int callTimeoutMillis(){ return 0; }
    public final int connectTimeoutMillis(){ return 0; }
    public final int pingIntervalMillis(){ return 0; }
    public final int readTimeoutMillis(){ return 0; }
    public final int writeTimeoutMillis(){ return 0; }
    public final long minWebSocketMessageToCompress(){ return 0; }
    public static OkHttpClient.Companion Companion = null;
    static public class Builder
    {
        public Builder(){}
        public Builder(OkHttpClient p0){}
        public final Authenticator getAuthenticator$okhttp(){ return null; }
        public final Authenticator getProxyAuthenticator$okhttp(){ return null; }
        public final Cache getCache$okhttp(){ return null; }
        public final CertificateChainCleaner getCertificateChainCleaner$okhttp(){ return null; }
        public final CertificatePinner getCertificatePinner$okhttp(){ return null; }
        public final ConnectionPool getConnectionPool$okhttp(){ return null; }
        public final CookieJar getCookieJar$okhttp(){ return null; }
        public final Dispatcher getDispatcher$okhttp(){ return null; }
        public final Dns getDns$okhttp(){ return null; }
        public final EventListener.Factory getEventListenerFactory$okhttp(){ return null; }
        public final HostnameVerifier getHostnameVerifier$okhttp(){ return null; }
        public final List<ConnectionSpec> getConnectionSpecs$okhttp(){ return null; }
        public final List<Interceptor> getInterceptors$okhttp(){ return null; }
        public final List<Interceptor> getNetworkInterceptors$okhttp(){ return null; }
        public final List<Interceptor> interceptors(){ return null; }
        public final List<Interceptor> networkInterceptors(){ return null; }
        public final List<Protocol> getProtocols$okhttp(){ return null; }
        public final OkHttpClient build(){ return null; }
        public final OkHttpClient.Builder addInterceptor(Interceptor p0){ return null; }
        public final OkHttpClient.Builder addNetworkInterceptor(Interceptor p0){ return null; }
        public final OkHttpClient.Builder authenticator(Authenticator p0){ return null; }
        public final OkHttpClient.Builder cache(Cache p0){ return null; }
        public final OkHttpClient.Builder callTimeout(Duration p0){ return null; }
        public final OkHttpClient.Builder callTimeout(long p0, TimeUnit p1){ return null; }
        public final OkHttpClient.Builder certificatePinner(CertificatePinner p0){ return null; }
        public final OkHttpClient.Builder connectTimeout(Duration p0){ return null; }
        public final OkHttpClient.Builder connectTimeout(long p0, TimeUnit p1){ return null; }
        public final OkHttpClient.Builder connectionPool(ConnectionPool p0){ return null; }
        public final OkHttpClient.Builder connectionSpecs(List<ConnectionSpec> p0){ return null; }
        public final OkHttpClient.Builder cookieJar(CookieJar p0){ return null; }
        public final OkHttpClient.Builder dispatcher(Dispatcher p0){ return null; }
        public final OkHttpClient.Builder dns(Dns p0){ return null; }
        public final OkHttpClient.Builder eventListener(EventListener p0){ return null; }
        public final OkHttpClient.Builder eventListenerFactory(EventListener.Factory p0){ return null; }
        public final OkHttpClient.Builder followRedirects(boolean p0){ return null; }
        public final OkHttpClient.Builder followSslRedirects(boolean p0){ return null; }
        public final OkHttpClient.Builder hostnameVerifier(HostnameVerifier p0){ return null; }
        public final OkHttpClient.Builder minWebSocketMessageToCompress(long p0){ return null; }
        public final OkHttpClient.Builder pingInterval(Duration p0){ return null; }
        public final OkHttpClient.Builder pingInterval(long p0, TimeUnit p1){ return null; }
        public final OkHttpClient.Builder protocols(List<? extends Protocol> p0){ return null; }
        public final OkHttpClient.Builder proxy(Proxy p0){ return null; }
        public final OkHttpClient.Builder proxyAuthenticator(Authenticator p0){ return null; }
        public final OkHttpClient.Builder proxySelector(ProxySelector p0){ return null; }
        public final OkHttpClient.Builder readTimeout(Duration p0){ return null; }
        public final OkHttpClient.Builder readTimeout(long p0, TimeUnit p1){ return null; }
        public final OkHttpClient.Builder retryOnConnectionFailure(boolean p0){ return null; }
        public final OkHttpClient.Builder socketFactory(SocketFactory p0){ return null; }
        public final OkHttpClient.Builder sslSocketFactory(SSLSocketFactory p0){ return null; }
        public final OkHttpClient.Builder sslSocketFactory(SSLSocketFactory p0, X509TrustManager p1){ return null; }
        public final OkHttpClient.Builder writeTimeout(Duration p0){ return null; }
        public final OkHttpClient.Builder writeTimeout(long p0, TimeUnit p1){ return null; }
        public final Proxy getProxy$okhttp(){ return null; }
        public final ProxySelector getProxySelector$okhttp(){ return null; }
        public final RouteDatabase getRouteDatabase$okhttp(){ return null; }
        public final SSLSocketFactory getSslSocketFactoryOrNull$okhttp(){ return null; }
        public final SocketFactory getSocketFactory$okhttp(){ return null; }
        public final X509TrustManager getX509TrustManagerOrNull$okhttp(){ return null; }
        public final boolean getFollowRedirects$okhttp(){ return false; }
        public final boolean getFollowSslRedirects$okhttp(){ return false; }
        public final boolean getRetryOnConnectionFailure$okhttp(){ return false; }
        public final int getCallTimeout$okhttp(){ return 0; }
        public final int getConnectTimeout$okhttp(){ return 0; }
        public final int getPingInterval$okhttp(){ return 0; }
        public final int getReadTimeout$okhttp(){ return 0; }
        public final int getWriteTimeout$okhttp(){ return 0; }
        public final long getMinWebSocketMessageToCompress$okhttp(){ return 0; }
        public final void setAuthenticator$okhttp(Authenticator p0){}
        public final void setCache$okhttp(Cache p0){}
        public final void setCallTimeout$okhttp(int p0){}
        public final void setCertificateChainCleaner$okhttp(CertificateChainCleaner p0){}
        public final void setCertificatePinner$okhttp(CertificatePinner p0){}
        public final void setConnectTimeout$okhttp(int p0){}
        public final void setConnectionPool$okhttp(ConnectionPool p0){}
        public final void setConnectionSpecs$okhttp(List<ConnectionSpec> p0){}
        public final void setCookieJar$okhttp(CookieJar p0){}
        public final void setDispatcher$okhttp(Dispatcher p0){}
        public final void setDns$okhttp(Dns p0){}
        public final void setEventListenerFactory$okhttp(EventListener.Factory p0){}
        public final void setFollowRedirects$okhttp(boolean p0){}
        public final void setFollowSslRedirects$okhttp(boolean p0){}
        public final void setHostnameVerifier$okhttp(HostnameVerifier p0){}
        public final void setMinWebSocketMessageToCompress$okhttp(long p0){}
        public final void setPingInterval$okhttp(int p0){}
        public final void setProtocols$okhttp(List<? extends Protocol> p0){}
        public final void setProxy$okhttp(Proxy p0){}
        public final void setProxyAuthenticator$okhttp(Authenticator p0){}
        public final void setProxySelector$okhttp(ProxySelector p0){}
        public final void setReadTimeout$okhttp(int p0){}
        public final void setRetryOnConnectionFailure$okhttp(boolean p0){}
        public final void setRouteDatabase$okhttp(RouteDatabase p0){}
        public final void setSocketFactory$okhttp(SocketFactory p0){}
        public final void setSslSocketFactoryOrNull$okhttp(SSLSocketFactory p0){}
        public final void setWriteTimeout$okhttp(int p0){}
        public final void setX509TrustManagerOrNull$okhttp(X509TrustManager p0){}
    }
    static public class Companion
    {
        protected Companion() {}
        public final List<ConnectionSpec> getDEFAULT_CONNECTION_SPECS$okhttp(){ return null; }
        public final List<Protocol> getDEFAULT_PROTOCOLS$okhttp(){ return null; }
    }
}
