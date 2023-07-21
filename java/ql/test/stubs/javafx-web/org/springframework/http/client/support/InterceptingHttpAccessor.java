// Generated automatically from org.springframework.http.client.support.InterceptingHttpAccessor for testing purposes

package org.springframework.http.client.support;

import java.util.List;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.support.HttpAccessor;

abstract public class InterceptingHttpAccessor extends HttpAccessor
{
    public ClientHttpRequestFactory getRequestFactory(){ return null; }
    public InterceptingHttpAccessor(){}
    public List<ClientHttpRequestInterceptor> getInterceptors(){ return null; }
    public void setInterceptors(List<ClientHttpRequestInterceptor> p0){}
    public void setRequestFactory(ClientHttpRequestFactory p0){}
}
