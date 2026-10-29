// Generated automatically from org.springframework.web.client.RestOperations for testing purposes

package org.springframework.web.client;

import java.net.URI;
import java.util.Map;
import java.util.Set;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.ResponseExtractor;

public interface RestOperations
{
    <T> T execute(String p0, HttpMethod p1, RequestCallback p2, org.springframework.web.client.ResponseExtractor<T> p3, Map<String, ? extends Object> p4);
    <T> T execute(String p0, HttpMethod p1, RequestCallback p2, org.springframework.web.client.ResponseExtractor<T> p3, Object... p4);
    <T> T execute(URI p0, HttpMethod p1, RequestCallback p2, org.springframework.web.client.ResponseExtractor<T> p3);
    <T> T getForObject(String p0, java.lang.Class<T> p1, Map<String, ? extends Object> p2);
    <T> T getForObject(String p0, java.lang.Class<T> p1, Object... p2);
    <T> T getForObject(URI p0, java.lang.Class<T> p1);
    <T> T patchForObject(String p0, Object p1, java.lang.Class<T> p2, Map<String, ? extends Object> p3);
    <T> T patchForObject(String p0, Object p1, java.lang.Class<T> p2, Object... p3);
    <T> T patchForObject(URI p0, Object p1, java.lang.Class<T> p2);
    <T> T postForObject(String p0, Object p1, java.lang.Class<T> p2, Map<String, ? extends Object> p3);
    <T> T postForObject(String p0, Object p1, java.lang.Class<T> p2, Object... p3);
    <T> T postForObject(URI p0, Object p1, java.lang.Class<T> p2);
    <T> org.springframework.http.ResponseEntity<T> exchange(RequestEntity<? extends Object> p0, java.lang.Class<T> p1);
    <T> org.springframework.http.ResponseEntity<T> exchange(RequestEntity<? extends Object> p0, org.springframework.core.ParameterizedTypeReference<T> p1);
    <T> org.springframework.http.ResponseEntity<T> exchange(String p0, HttpMethod p1, HttpEntity<? extends Object> p2, java.lang.Class<T> p3, Map<String, ? extends Object> p4);
    <T> org.springframework.http.ResponseEntity<T> exchange(String p0, HttpMethod p1, HttpEntity<? extends Object> p2, java.lang.Class<T> p3, Object... p4);
    <T> org.springframework.http.ResponseEntity<T> exchange(String p0, HttpMethod p1, HttpEntity<? extends Object> p2, org.springframework.core.ParameterizedTypeReference<T> p3, Map<String, ? extends Object> p4);
    <T> org.springframework.http.ResponseEntity<T> exchange(String p0, HttpMethod p1, HttpEntity<? extends Object> p2, org.springframework.core.ParameterizedTypeReference<T> p3, Object... p4);
    <T> org.springframework.http.ResponseEntity<T> exchange(URI p0, HttpMethod p1, HttpEntity<? extends Object> p2, java.lang.Class<T> p3);
    <T> org.springframework.http.ResponseEntity<T> exchange(URI p0, HttpMethod p1, HttpEntity<? extends Object> p2, org.springframework.core.ParameterizedTypeReference<T> p3);
    <T> org.springframework.http.ResponseEntity<T> getForEntity(String p0, java.lang.Class<T> p1, Map<String, ? extends Object> p2);
    <T> org.springframework.http.ResponseEntity<T> getForEntity(String p0, java.lang.Class<T> p1, Object... p2);
    <T> org.springframework.http.ResponseEntity<T> getForEntity(URI p0, java.lang.Class<T> p1);
    <T> org.springframework.http.ResponseEntity<T> postForEntity(String p0, Object p1, java.lang.Class<T> p2, Map<String, ? extends Object> p3);
    <T> org.springframework.http.ResponseEntity<T> postForEntity(String p0, Object p1, java.lang.Class<T> p2, Object... p3);
    <T> org.springframework.http.ResponseEntity<T> postForEntity(URI p0, Object p1, java.lang.Class<T> p2);
    HttpHeaders headForHeaders(String p0, Map<String, ? extends Object> p1);
    HttpHeaders headForHeaders(String p0, Object... p1);
    HttpHeaders headForHeaders(URI p0);
    Set<HttpMethod> optionsForAllow(String p0, Map<String, ? extends Object> p1);
    Set<HttpMethod> optionsForAllow(String p0, Object... p1);
    Set<HttpMethod> optionsForAllow(URI p0);
    URI postForLocation(String p0, Object p1, Map<String, ? extends Object> p2);
    URI postForLocation(String p0, Object p1, Object... p2);
    URI postForLocation(URI p0, Object p1);
    void delete(String p0, Map<String, ? extends Object> p1);
    void delete(String p0, Object... p1);
    void delete(URI p0);
    void put(String p0, Object p1, Map<String, ? extends Object> p2);
    void put(String p0, Object p1, Object... p2);
    void put(URI p0, Object p1);
}
