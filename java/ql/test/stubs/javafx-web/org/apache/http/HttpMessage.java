// Generated automatically from org.apache.http.HttpMessage for testing purposes

package org.apache.http;

import org.apache.http.Header;
import org.apache.http.HeaderIterator;
import org.apache.http.ProtocolVersion;
import org.apache.http.params.HttpParams;

public interface HttpMessage
{
    Header getFirstHeader(String p0);
    Header getLastHeader(String p0);
    HeaderIterator headerIterator();
    HeaderIterator headerIterator(String p0);
    Header[] getAllHeaders();
    Header[] getHeaders(String p0);
    HttpParams getParams();
    ProtocolVersion getProtocolVersion();
    boolean containsHeader(String p0);
    void addHeader(Header p0);
    void addHeader(String p0, String p1);
    void removeHeader(Header p0);
    void removeHeaders(String p0);
    void setHeader(Header p0);
    void setHeader(String p0, String p1);
    void setHeaders(Header[] p0);
    void setParams(HttpParams p0);
}
