// Generated automatically from org.apache.hc.core5.http.nio.ssl.TlsStrategy for testing purposes

package org.apache.hc.core5.http.nio.ssl;

import java.net.SocketAddress;
import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.net.NamedEndpoint;
import org.apache.hc.core5.reactor.ssl.TransportSecurityLayer;
import org.apache.hc.core5.util.Timeout;

public interface TlsStrategy
{
    boolean upgrade(TransportSecurityLayer p0, HttpHost p1, SocketAddress p2, SocketAddress p3, Object p4, Timeout p5);
    default void upgrade(TransportSecurityLayer p0, NamedEndpoint p1, Object p2, Timeout p3, FutureCallback<TransportSecurityLayer> p4){}
}
