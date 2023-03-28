// Generated automatically from org.apache.http.StatusLine for testing purposes

package org.apache.http;

import org.apache.http.ProtocolVersion;

public interface StatusLine
{
    ProtocolVersion getProtocolVersion();
    String getReasonPhrase();
    int getStatusCode();
}
