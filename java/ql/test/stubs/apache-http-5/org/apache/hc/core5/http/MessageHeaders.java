// Generated automatically from org.apache.hc.core5.http.MessageHeaders for testing purposes

package org.apache.hc.core5.http;

import java.util.Iterator;
import org.apache.hc.core5.http.Header;

public interface MessageHeaders
{
    Header getFirstHeader(String p0);
    Header getHeader(String p0);
    Header getLastHeader(String p0);
    Header[] getHeaders();
    Header[] getHeaders(String p0);
    Iterator<Header> headerIterator();
    Iterator<Header> headerIterator(String p0);
    boolean containsHeader(String p0);
    int countHeaders(String p0);
}
