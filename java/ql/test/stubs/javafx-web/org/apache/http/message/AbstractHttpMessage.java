// Generated automatically from org.apache.http.message.AbstractHttpMessage for testing purposes

package org.apache.http.message;

import org.apache.http.Header;
import org.apache.http.HeaderIterator;
import org.apache.http.HttpMessage;
import org.apache.http.message.HeaderGroup;
import org.apache.http.params.HttpParams;

abstract public class AbstractHttpMessage implements HttpMessage
{
    protected AbstractHttpMessage(){}
    protected AbstractHttpMessage(HttpParams p0){}
    protected HeaderGroup headergroup = null;
    protected HttpParams params = null;
    public Header getFirstHeader(String p0){ return null; }
    public Header getLastHeader(String p0){ return null; }
    public HeaderIterator headerIterator(){ return null; }
    public HeaderIterator headerIterator(String p0){ return null; }
    public Header[] getAllHeaders(){ return null; }
    public Header[] getHeaders(String p0){ return null; }
    public HttpParams getParams(){ return null; }
    public boolean containsHeader(String p0){ return false; }
    public void addHeader(Header p0){}
    public void addHeader(String p0, String p1){}
    public void removeHeader(Header p0){}
    public void removeHeaders(String p0){}
    public void setHeader(Header p0){}
    public void setHeader(String p0, String p1){}
    public void setHeaders(Header[] p0){}
    public void setParams(HttpParams p0){}
}
