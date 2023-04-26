// Generated automatically from org.apache.hc.core5.http.protocol.HttpContext for testing purposes

package org.apache.hc.core5.http.protocol;

import org.apache.hc.core5.http.ProtocolVersion;

public interface HttpContext
{
    Object getAttribute(String p0);
    Object removeAttribute(String p0);
    Object setAttribute(String p0, Object p1);
    ProtocolVersion getProtocolVersion();
    static String RESERVED_PREFIX = null;
    void setProtocolVersion(ProtocolVersion p0);
}
