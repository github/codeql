// Generated automatically from org.apache.hc.core5.http.HttpMessage for testing purposes

package org.apache.hc.core5.http;

import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.MessageHeaders;
import org.apache.hc.core5.http.ProtocolVersion;

public interface HttpMessage extends MessageHeaders
{
    ProtocolVersion getVersion();
    boolean removeHeader(Header p0);
    boolean removeHeaders(String p0);
    void addHeader(Header p0);
    void addHeader(String p0, Object p1);
    void setHeader(Header p0);
    void setHeader(String p0, Object p1);
    void setHeaders(Header... p0);
    void setVersion(ProtocolVersion p0);
}
