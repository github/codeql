// Generated automatically from com.google.common.collect.ClassToInstanceMap for testing purposes

package com.google.common.collect;

import java.util.Map;

public interface ClassToInstanceMap<B> extends Map<Class<? extends B>, B>
{
    <T extends B> T getInstance(Class<T> p0);
    <T extends B> T putInstance(Class<T> p0, T p1);
}
