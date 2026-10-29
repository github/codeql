// Generated automatically from org.apache.hc.client5.http.impl.classic.CloseableHttpResponse for testing purposes

package org.apache.hc.client5.http.impl.classic;

import java.util.Iterator;
import java.util.Locale;
import org.apache.hc.core5.http.ClassicHttpResponse;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.ProtocolVersion;

public class CloseableHttpResponse implements ClassicHttpResponse
{
    protected CloseableHttpResponse() {}
    public Header getFirstHeader(String p0){ return null; }
    public Header getHeader(String p0){ return null; }
    public Header getLastHeader(String p0){ return null; }
    public Header[] getHeaders(){ return null; }
    public Header[] getHeaders(String p0){ return null; }
    public HttpEntity getEntity(){ return null; }
    public Iterator<Header> headerIterator(){ return null; }
    public Iterator<Header> headerIterator(String p0){ return null; }
    public Locale getLocale(){ return null; }
    public ProtocolVersion getVersion(){ return null; }
    public String getReasonPhrase(){ return null; }
    public String toString(){ return null; }
    public boolean containsHeader(String p0){ return false; }
    public boolean removeHeader(Header p0){ return false; }
    public boolean removeHeaders(String p0){ return false; }
    public int countHeaders(String p0){ return 0; }
    public int getCode(){ return 0; }
    public void addHeader(Header p0){}
    public void addHeader(String p0, Object p1){}
    public void close(){}
    public void setCode(int p0){}
    public void setEntity(HttpEntity p0){}
    public void setHeader(Header p0){}
    public void setHeader(String p0, Object p1){}
    public void setHeaders(Header... p0){}
    public void setLocale(Locale p0){}
    public void setReasonPhrase(String p0){}
    public void setVersion(ProtocolVersion p0){}
}
