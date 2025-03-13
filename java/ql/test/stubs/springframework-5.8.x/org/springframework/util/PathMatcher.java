// Generated automatically from org.springframework.util.PathMatcher for testing purposes

package org.springframework.util;

import java.util.Comparator;
import java.util.Map;

public interface PathMatcher
{
    Comparator<String> getPatternComparator(String p0);
    Map<String, String> extractUriTemplateVariables(String p0, String p1);
    String combine(String p0, String p1);
    String extractPathWithinPattern(String p0, String p1);
    boolean isPattern(String p0);
    boolean match(String p0, String p1);
    boolean matchStart(String p0, String p1);
}
