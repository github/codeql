// Generated automatically from org.apache.hc.core5.reactor.ssl.SSLSessionVerifier for testing purposes

package org.apache.hc.core5.reactor.ssl;

import javax.net.ssl.SSLEngine;
import org.apache.hc.core5.net.NamedEndpoint;
import org.apache.hc.core5.reactor.ssl.TlsDetails;

public interface SSLSessionVerifier
{
    TlsDetails verify(NamedEndpoint p0, SSLEngine p1);
}
