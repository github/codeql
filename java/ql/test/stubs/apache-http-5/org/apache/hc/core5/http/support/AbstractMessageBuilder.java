// Generated automatically from org.apache.hc.core5.http.support.AbstractMessageBuilder for testing purposes

package org.apache.hc.core5.http.support;

import java.util.Iterator;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpMessage;
import org.apache.hc.core5.http.ProtocolVersion;

abstract public class AbstractMessageBuilder<T>
{
    protected AbstractMessageBuilder(){}
    protected abstract T build();
    protected void digest(HttpMessage p0){}
    public AbstractMessageBuilder<T> addHeader(Header p0){ return null; }
    public AbstractMessageBuilder<T> addHeader(String p0, String p1){ return null; }
    public AbstractMessageBuilder<T> removeHeader(Header p0){ return null; }
    public AbstractMessageBuilder<T> removeHeaders(String p0){ return null; }
    public AbstractMessageBuilder<T> setHeader(Header p0){ return null; }
    public AbstractMessageBuilder<T> setHeader(String p0, String p1){ return null; }
    public AbstractMessageBuilder<T> setHeaders(Header... p0){ return null; }
    public AbstractMessageBuilder<T> setHeaders(Iterator<Header> p0){ return null; }
    public AbstractMessageBuilder<T> setVersion(ProtocolVersion p0){ return null; }
    public Header getFirstHeader(String p0){ return null; }
    public Header getLastHeader(String p0){ return null; }
    public Header[] getFirstHeaders(){ return null; }
    public Header[] getHeaders(){ return null; }
    public Header[] getHeaders(String p0){ return null; }
    public ProtocolVersion getVersion(){ return null; }
}
