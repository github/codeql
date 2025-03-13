// Generated automatically from org.springframework.util.RouteMatcher for testing purposes

package org.springframework.util;

import java.util.Comparator;
import java.util.Map;

public interface RouteMatcher
{
    Comparator<String> getPatternComparator(RouteMatcher.Route p0);
    Map<String, String> matchAndExtract(String p0, RouteMatcher.Route p1);
    RouteMatcher.Route parseRoute(String p0);
    String combine(String p0, String p1);
    boolean isPattern(String p0);
    boolean match(String p0, RouteMatcher.Route p1);
    static public interface Route
    {
        String value();
    }
}
