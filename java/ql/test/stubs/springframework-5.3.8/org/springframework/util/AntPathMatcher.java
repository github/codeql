// Generated automatically from org.springframework.util.AntPathMatcher for testing purposes

package org.springframework.util;

import java.util.Comparator;
import java.util.Map;
import org.springframework.util.PathMatcher;

public class AntPathMatcher implements PathMatcher
{
    final Map<String, AntPathMatcher.AntPathStringMatcher> stringMatcherCache = null;
    protected AntPathMatcher.AntPathStringMatcher getStringMatcher(String p0){ return null; }
    protected String[] tokenizePath(String p0){ return null; }
    protected String[] tokenizePattern(String p0){ return null; }
    protected boolean doMatch(String p0, String p1, boolean p2, Map<String, String> p3){ return false; }
    public AntPathMatcher(){}
    public AntPathMatcher(String p0){}
    public Comparator<String> getPatternComparator(String p0){ return null; }
    public Map<String, String> extractUriTemplateVariables(String p0, String p1){ return null; }
    public String combine(String p0, String p1){ return null; }
    public String extractPathWithinPattern(String p0, String p1){ return null; }
    public boolean isPattern(String p0){ return false; }
    public boolean match(String p0, String p1){ return false; }
    public boolean matchStart(String p0, String p1){ return false; }
    public static String DEFAULT_PATH_SEPARATOR = null;
    public void setCachePatterns(boolean p0){}
    public void setCaseSensitive(boolean p0){}
    public void setPathSeparator(String p0){}
    public void setTrimTokens(boolean p0){}
    static class AntPathStringMatcher
    {
        protected AntPathStringMatcher() {}
        public AntPathStringMatcher(String p0){}
        public AntPathStringMatcher(String p0, boolean p1){}
        public boolean matchStrings(String p0, Map<String, String> p1){ return false; }
    }
}
