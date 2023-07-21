// Generated automatically from org.springframework.http.server.reactive.SslInfo for testing purposes

package org.springframework.http.server.reactive;

import java.security.cert.X509Certificate;

public interface SslInfo
{
    String getSessionId();
    X509Certificate[] getPeerCertificates();
}
