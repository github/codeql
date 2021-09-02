// Generated automatically from org.springframework.web.method.support.HandlerMethodArgumentResolver for testing purposes

package org.springframework.web.method.support;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.ModelAndViewContainer;

public interface HandlerMethodArgumentResolver
{
    Object resolveArgument(MethodParameter p0, ModelAndViewContainer p1, NativeWebRequest p2, WebDataBinderFactory p3);
    boolean supportsParameter(MethodParameter p0);
}
