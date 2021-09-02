// Generated automatically from org.springframework.core.AttributeAccessor for testing purposes

package org.springframework.core;

import java.util.function.Function;

public interface AttributeAccessor
{
    Object getAttribute(String p0);
    Object removeAttribute(String p0);
    String[] attributeNames();
    boolean hasAttribute(String p0);
    default <T> T computeAttribute(String p0, Function<String, T> p1){ return null; }
    void setAttribute(String p0, Object p1);
}
