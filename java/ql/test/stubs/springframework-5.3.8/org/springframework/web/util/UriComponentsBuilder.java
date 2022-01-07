// Generated automatically from org.springframework.web.util.UriComponentsBuilder for testing purposes

package org.springframework.web.util;

import java.net.InetSocketAddress;
import java.net.URI;
import java.nio.charset.Charset;
import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpRequest;
import org.springframework.util.MultiValueMap;
import org.springframework.web.util.UriBuilder;
import org.springframework.web.util.UriComponents;

public class UriComponentsBuilder implements Cloneable, UriBuilder
{
    UriComponentsBuilder adaptFromForwardedHeaders(HttpHeaders p0){ return null; }
    protected UriComponentsBuilder(){}
    protected UriComponentsBuilder(UriComponentsBuilder p0){}
    public Object clone(){ return null; }
    public String toUriString(){ return null; }
    public URI build(Map<String, ? extends Object> p0){ return null; }
    public URI build(Object... p0){ return null; }
    public UriComponents build(){ return null; }
    public UriComponents build(boolean p0){ return null; }
    public UriComponents buildAndExpand(Map<String, ? extends Object> p0){ return null; }
    public UriComponents buildAndExpand(Object... p0){ return null; }
    public UriComponentsBuilder cloneBuilder(){ return null; }
    public UriComponentsBuilder encode(Charset p0){ return null; }
    public UriComponentsBuilder fragment(String p0){ return null; }
    public UriComponentsBuilder host(String p0){ return null; }
    public UriComponentsBuilder path(String p0){ return null; }
    public UriComponentsBuilder pathSegment(String... p0){ return null; }
    public UriComponentsBuilder port(String p0){ return null; }
    public UriComponentsBuilder port(int p0){ return null; }
    public UriComponentsBuilder query(String p0){ return null; }
    public UriComponentsBuilder queryParam(String p0, Collection<? extends Object> p1){ return null; }
    public UriComponentsBuilder queryParam(String p0, Object... p1){ return null; }
    public UriComponentsBuilder queryParamIfPresent(String p0, Optional<? extends Object> p1){ return null; }
    public UriComponentsBuilder queryParams(MultiValueMap<String, String> p0){ return null; }
    public UriComponentsBuilder replacePath(String p0){ return null; }
    public UriComponentsBuilder replaceQuery(String p0){ return null; }
    public UriComponentsBuilder replaceQueryParam(String p0, Collection<? extends Object> p1){ return null; }
    public UriComponentsBuilder replaceQueryParam(String p0, Object... p1){ return null; }
    public UriComponentsBuilder replaceQueryParams(MultiValueMap<String, String> p0){ return null; }
    public UriComponentsBuilder scheme(String p0){ return null; }
    public UriComponentsBuilder schemeSpecificPart(String p0){ return null; }
    public UriComponentsBuilder uri(URI p0){ return null; }
    public UriComponentsBuilder uriComponents(UriComponents p0){ return null; }
    public UriComponentsBuilder uriVariables(Map<String, Object> p0){ return null; }
    public UriComponentsBuilder userInfo(String p0){ return null; }
    public final UriComponentsBuilder encode(){ return null; }
    public static InetSocketAddress parseForwardedFor(HttpRequest p0, InetSocketAddress p1){ return null; }
    public static UriComponentsBuilder fromHttpRequest(HttpRequest p0){ return null; }
    public static UriComponentsBuilder fromHttpUrl(String p0){ return null; }
    public static UriComponentsBuilder fromOriginHeader(String p0){ return null; }
    public static UriComponentsBuilder fromPath(String p0){ return null; }
    public static UriComponentsBuilder fromUri(URI p0){ return null; }
    public static UriComponentsBuilder fromUriString(String p0){ return null; }
    public static UriComponentsBuilder newInstance(){ return null; }
}
