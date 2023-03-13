// Generated automatically from org.apache.http.client.methods.HttpRequestBase for testing purposes

package org.apache.http.client.methods;

import java.net.URI;
import org.apache.http.ProtocolVersion;
import org.apache.http.RequestLine;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.AbstractExecutionAwareRequest;
import org.apache.http.client.methods.Configurable;
import org.apache.http.client.methods.HttpUriRequest;

abstract public class HttpRequestBase extends AbstractExecutionAwareRequest implements Configurable, HttpUriRequest
{
    public HttpRequestBase(){}
    public ProtocolVersion getProtocolVersion(){ return null; }
    public RequestConfig getConfig(){ return null; }
    public RequestLine getRequestLine(){ return null; }
    public String toString(){ return null; }
    public URI getURI(){ return null; }
    public abstract String getMethod();
    public void releaseConnection(){}
    public void setConfig(RequestConfig p0){}
    public void setProtocolVersion(ProtocolVersion p0){}
    public void setURI(URI p0){}
    public void started(){}
}
