// Generated automatically from org.springframework.http.HttpEntity for testing purposes

package org.springframework.http;

import org.springframework.http.HttpHeaders;
import org.springframework.util.MultiValueMap;

public class HttpEntity<T>
{
    protected HttpEntity(){}
    public HttpEntity(MultiValueMap<String, String> p0){}
    public HttpEntity(T p0){}
    public HttpEntity(T p0, MultiValueMap<String, String> p1){}
    public HttpHeaders getHeaders(){ return null; }
    public String toString(){ return null; }
    public T getBody(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean hasBody(){ return false; }
    public int hashCode(){ return 0; }
    public static HttpEntity<? extends Object> EMPTY = null;
}
