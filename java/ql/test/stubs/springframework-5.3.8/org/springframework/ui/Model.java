// Generated automatically from org.springframework.ui.Model for testing purposes

package org.springframework.ui;

import java.util.Collection;
import java.util.Map;

public interface Model
{
    Map<String, Object> asMap();
    Model addAllAttributes(Collection<? extends Object> p0);
    Model addAllAttributes(Map<String, ? extends Object> p0);
    Model addAttribute(Object p0);
    Model addAttribute(String p0, Object p1);
    Model mergeAttributes(Map<String, ? extends Object> p0);
    Object getAttribute(String p0);
    boolean containsAttribute(String p0);
}
