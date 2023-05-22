// Generated automatically from org.apache.hc.core5.http.message.AbstractMessageWrapper for testing purposes

package org.apache.hc.core5.http.message;

import java.util.Iterator;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpMessage;
import org.apache.hc.core5.http.ProtocolVersion;

abstract public class AbstractMessageWrapper implements HttpMessage
{
    protected AbstractMessageWrapper() {}
    public AbstractMessageWrapper(HttpMessage p0){}
    public Header getFirstHeader(String p0){ return null; }
    public Header getHeader(String p0){ return null; }
    public Header getLastHeader(String p0){ return null; }
    public Header[] getHeaders(){ return null; }
    public Header[] getHeaders(String p0){ return null; }
    public Iterator<Header> headerIterator(){ return null; }
    public Iterator<Header> headerIterator(String p0){ return null; }
    public ProtocolVersion getVersion(){ return null; }
    public String toString(){ return null; }
    public boolean containsHeader(String p0){ return false; }
    public boolean removeHeader(Header p0){ return false; }
    public boolean removeHeaders(String p0){ return false; }
    public int countHeaders(String p0){ return 0; }
    public void addHeader(Header p0){}
    public void addHeader(String p0, Object p1){}
    public void setHeader(Header p0){}
    public void setHeader(String p0, Object p1){}
    public void setHeaders(Header... p0){}
    public void setVersion(ProtocolVersion p0){}
}
