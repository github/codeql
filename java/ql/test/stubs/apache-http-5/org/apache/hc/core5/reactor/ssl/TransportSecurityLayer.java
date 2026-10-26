// Generated automatically from org.apache.hc.core5.reactor.ssl.TransportSecurityLayer for testing purposes

package org.apache.hc.core5.reactor.ssl;

import javax.net.ssl.SSLContext;
import org.apache.hc.core5.concurrent.FutureCallback;
import org.apache.hc.core5.net.NamedEndpoint;
import org.apache.hc.core5.reactor.ssl.SSLBufferMode;
import org.apache.hc.core5.reactor.ssl.SSLSessionInitializer;
import org.apache.hc.core5.reactor.ssl.SSLSessionVerifier;
import org.apache.hc.core5.reactor.ssl.TlsDetails;
import org.apache.hc.core5.util.Timeout;

public interface TransportSecurityLayer
{
    TlsDetails getTlsDetails();
    default void startTls(SSLContext p0, NamedEndpoint p1, SSLBufferMode p2, SSLSessionInitializer p3, SSLSessionVerifier p4, Timeout p5, FutureCallback<TransportSecurityLayer> p6){}
    void startTls(SSLContext p0, NamedEndpoint p1, SSLBufferMode p2, SSLSessionInitializer p3, SSLSessionVerifier p4, Timeout p5);
}
