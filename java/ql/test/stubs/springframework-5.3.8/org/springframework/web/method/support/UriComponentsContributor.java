// Generated automatically from org.springframework.web.method.support.UriComponentsContributor for testing purposes

package org.springframework.web.method.support;

import java.util.Map;
import org.springframework.core.MethodParameter;
import org.springframework.core.convert.ConversionService;
import org.springframework.web.util.UriComponentsBuilder;

public interface UriComponentsContributor
{
    boolean supportsParameter(MethodParameter p0);
    void contributeMethodArgument(MethodParameter p0, Object p1, UriComponentsBuilder p2, Map<String, Object> p3, ConversionService p4);
}
