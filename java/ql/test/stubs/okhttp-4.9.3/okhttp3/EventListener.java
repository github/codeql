// Generated automatically from okhttp3.EventListener for testing purposes

package okhttp3;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.util.List;
import okhttp3.Call;
import okhttp3.Connection;
import okhttp3.Handshake;
import okhttp3.HttpUrl;
import okhttp3.Protocol;
import okhttp3.Request;
import okhttp3.Response;

abstract public class EventListener
{
    public EventListener(){}
    public static EventListener NONE = null;
    public static EventListener.Companion Companion = null;
    public void cacheConditionalHit(Call p0, Response p1){}
    public void cacheHit(Call p0, Response p1){}
    public void cacheMiss(Call p0){}
    public void callEnd(Call p0){}
    public void callFailed(Call p0, IOException p1){}
    public void callStart(Call p0){}
    public void canceled(Call p0){}
    public void connectEnd(Call p0, InetSocketAddress p1, Proxy p2, Protocol p3){}
    public void connectFailed(Call p0, InetSocketAddress p1, Proxy p2, Protocol p3, IOException p4){}
    public void connectStart(Call p0, InetSocketAddress p1, Proxy p2){}
    public void connectionAcquired(Call p0, Connection p1){}
    public void connectionReleased(Call p0, Connection p1){}
    public void dnsEnd(Call p0, String p1, List<InetAddress> p2){}
    public void dnsStart(Call p0, String p1){}
    public void proxySelectEnd(Call p0, HttpUrl p1, List<Proxy> p2){}
    public void proxySelectStart(Call p0, HttpUrl p1){}
    public void requestBodyEnd(Call p0, long p1){}
    public void requestBodyStart(Call p0){}
    public void requestFailed(Call p0, IOException p1){}
    public void requestHeadersEnd(Call p0, Request p1){}
    public void requestHeadersStart(Call p0){}
    public void responseBodyEnd(Call p0, long p1){}
    public void responseBodyStart(Call p0){}
    public void responseFailed(Call p0, IOException p1){}
    public void responseHeadersEnd(Call p0, Response p1){}
    public void responseHeadersStart(Call p0){}
    public void satisfactionFailure(Call p0, Response p1){}
    public void secureConnectEnd(Call p0, Handshake p1){}
    public void secureConnectStart(Call p0){}
    static public class Companion
    {
        protected Companion() {}
    }
    static public interface Factory
    {
        EventListener create(Call p0);
    }
}
