// Generated automatically from org.springframework.http.client.support.HttpAccessor for testing purposes

package org.springframework.http.client.support;

import java.net.URI;
import java.util.List;
import org.apache.commons.logging.Log;
import org.springframework.http.HttpMethod;
import org.springframework.http.client.ClientHttpRequest;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.ClientHttpRequestInitializer;

abstract public class HttpAccessor
{
    protected ClientHttpRequest createRequest(URI p0, HttpMethod p1){ return null; }
    protected final Log logger = null;
    public ClientHttpRequestFactory getRequestFactory(){ return null; }
    public HttpAccessor(){}
    public List<ClientHttpRequestInitializer> getClientHttpRequestInitializers(){ return null; }
    public void setClientHttpRequestInitializers(List<ClientHttpRequestInitializer> p0){}
    public void setRequestFactory(ClientHttpRequestFactory p0){}
}
