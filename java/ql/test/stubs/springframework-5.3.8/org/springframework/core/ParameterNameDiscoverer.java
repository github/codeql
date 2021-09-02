// Generated automatically from org.springframework.core.ParameterNameDiscoverer for testing purposes

package org.springframework.core;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

public interface ParameterNameDiscoverer
{
    String[] getParameterNames(Constructor<? extends Object> p0);
    String[] getParameterNames(Method p0);
}
