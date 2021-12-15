// Generated automatically from org.springframework.web.util.UriBuilder for testing purposes

package org.springframework.web.util;

import java.net.URI;
import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import org.springframework.util.MultiValueMap;

public interface UriBuilder
{
    URI build(Map<String, ? extends Object> p0);
    URI build(Object... p0);
    UriBuilder fragment(String p0);
    UriBuilder host(String p0);
    UriBuilder path(String p0);
    UriBuilder pathSegment(String... p0);
    UriBuilder port(String p0);
    UriBuilder port(int p0);
    UriBuilder query(String p0);
    UriBuilder queryParam(String p0, Collection<? extends Object> p1);
    UriBuilder queryParam(String p0, Object... p1);
    UriBuilder queryParamIfPresent(String p0, Optional<? extends Object> p1);
    UriBuilder queryParams(MultiValueMap<String, String> p0);
    UriBuilder replacePath(String p0);
    UriBuilder replaceQuery(String p0);
    UriBuilder replaceQueryParam(String p0, Collection<? extends Object> p1);
    UriBuilder replaceQueryParam(String p0, Object... p1);
    UriBuilder replaceQueryParams(MultiValueMap<String, String> p0);
    UriBuilder scheme(String p0);
    UriBuilder userInfo(String p0);
}
