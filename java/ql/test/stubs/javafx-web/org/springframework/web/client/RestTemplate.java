// Generated automatically from org.springframework.web.client.RestTemplate for testing purposes

package org.springframework.web.client;

import java.lang.reflect.Type;
import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.http.client.support.InterceptingHttpAccessor;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.ResponseErrorHandler;
import org.springframework.web.client.ResponseExtractor;
import org.springframework.web.client.RestOperations;
import org.springframework.web.util.UriTemplateHandler;

public class RestTemplate extends InterceptingHttpAccessor implements RestOperations
{
    protected <T> T doExecute(URI p0, HttpMethod p1, RequestCallback p2, org.springframework.web.client.ResponseExtractor<T> p3){ return null; }
    protected ResponseExtractor<HttpHeaders> headersExtractor(){ return null; }
    protected void handleResponse(URI p0, HttpMethod p1, ClientHttpResponse p2){}
    public <T> RequestCallback acceptHeaderRequestCallback(java.lang.Class<T> p0){ return null; }
    public <T> RequestCallback httpEntityCallback(Object p0){ return null; }
    public <T> RequestCallback httpEntityCallback(Object p0, Type p1){ return null; }
    public <T> ResponseExtractor<org.springframework.http.ResponseEntity<T>> responseEntityExtractor(Type p0){ return null; }
    public <T> T execute(String p0, HttpMethod p1, RequestCallback p2, org.springframework.web.client.ResponseExtractor<T> p3, Map<String, ? extends Object> p4){ return null; }
    public <T> T execute(String p0, HttpMethod p1, RequestCallback p2, org.springframework.web.client.ResponseExtractor<T> p3, Object... p4){ return null; }
    public <T> T execute(URI p0, HttpMethod p1, RequestCallback p2, org.springframework.web.client.ResponseExtractor<T> p3){ return null; }
    public <T> T getForObject(String p0, java.lang.Class<T> p1, Map<String, ? extends Object> p2){ return null; }
    public <T> T getForObject(String p0, java.lang.Class<T> p1, Object... p2){ return null; }
    public <T> T getForObject(URI p0, java.lang.Class<T> p1){ return null; }
    public <T> T patchForObject(String p0, Object p1, java.lang.Class<T> p2, Map<String, ? extends Object> p3){ return null; }
    public <T> T patchForObject(String p0, Object p1, java.lang.Class<T> p2, Object... p3){ return null; }
    public <T> T patchForObject(URI p0, Object p1, java.lang.Class<T> p2){ return null; }
    public <T> T postForObject(String p0, Object p1, java.lang.Class<T> p2, Map<String, ? extends Object> p3){ return null; }
    public <T> T postForObject(String p0, Object p1, java.lang.Class<T> p2, Object... p3){ return null; }
    public <T> T postForObject(URI p0, Object p1, java.lang.Class<T> p2){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> exchange(RequestEntity<? extends Object> p0, java.lang.Class<T> p1){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> exchange(RequestEntity<? extends Object> p0, org.springframework.core.ParameterizedTypeReference<T> p1){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> exchange(String p0, HttpMethod p1, HttpEntity<? extends Object> p2, java.lang.Class<T> p3, Map<String, ? extends Object> p4){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> exchange(String p0, HttpMethod p1, HttpEntity<? extends Object> p2, java.lang.Class<T> p3, Object... p4){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> exchange(String p0, HttpMethod p1, HttpEntity<? extends Object> p2, org.springframework.core.ParameterizedTypeReference<T> p3, Map<String, ? extends Object> p4){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> exchange(String p0, HttpMethod p1, HttpEntity<? extends Object> p2, org.springframework.core.ParameterizedTypeReference<T> p3, Object... p4){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> exchange(URI p0, HttpMethod p1, HttpEntity<? extends Object> p2, java.lang.Class<T> p3){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> exchange(URI p0, HttpMethod p1, HttpEntity<? extends Object> p2, org.springframework.core.ParameterizedTypeReference<T> p3){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> getForEntity(String p0, java.lang.Class<T> p1, Map<String, ? extends Object> p2){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> getForEntity(String p0, java.lang.Class<T> p1, Object... p2){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> getForEntity(URI p0, java.lang.Class<T> p1){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> postForEntity(String p0, Object p1, java.lang.Class<T> p2, Map<String, ? extends Object> p3){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> postForEntity(String p0, Object p1, java.lang.Class<T> p2, Object... p3){ return null; }
    public <T> org.springframework.http.ResponseEntity<T> postForEntity(URI p0, Object p1, java.lang.Class<T> p2){ return null; }
    public HttpHeaders headForHeaders(String p0, Map<String, ? extends Object> p1){ return null; }
    public HttpHeaders headForHeaders(String p0, Object... p1){ return null; }
    public HttpHeaders headForHeaders(URI p0){ return null; }
    public List<HttpMessageConverter<? extends Object>> getMessageConverters(){ return null; }
    public ResponseErrorHandler getErrorHandler(){ return null; }
    public RestTemplate(){}
    public RestTemplate(ClientHttpRequestFactory p0){}
    public RestTemplate(List<HttpMessageConverter<? extends Object>> p0){}
    public Set<HttpMethod> optionsForAllow(String p0, Map<String, ? extends Object> p1){ return null; }
    public Set<HttpMethod> optionsForAllow(String p0, Object... p1){ return null; }
    public Set<HttpMethod> optionsForAllow(URI p0){ return null; }
    public URI postForLocation(String p0, Object p1, Map<String, ? extends Object> p2){ return null; }
    public URI postForLocation(String p0, Object p1, Object... p2){ return null; }
    public URI postForLocation(URI p0, Object p1){ return null; }
    public UriTemplateHandler getUriTemplateHandler(){ return null; }
    public void delete(String p0, Map<String, ? extends Object> p1){}
    public void delete(String p0, Object... p1){}
    public void delete(URI p0){}
    public void put(String p0, Object p1, Map<String, ? extends Object> p2){}
    public void put(String p0, Object p1, Object... p2){}
    public void put(URI p0, Object p1){}
    public void setDefaultUriVariables(Map<String, ? extends Object> p0){}
    public void setErrorHandler(ResponseErrorHandler p0){}
    public void setMessageConverters(List<HttpMessageConverter<? extends Object>> p0){}
    public void setUriTemplateHandler(UriTemplateHandler p0){}
}
