// Generated automatically from org.apache.tools.ant.util.regexp.RegexpMatcher for testing purposes

package org.apache.tools.ant.util.regexp;

import java.util.Vector;

public interface RegexpMatcher
{
    String getPattern();
    Vector<String> getGroups(String p0);
    Vector<String> getGroups(String p0, int p1);
    boolean matches(String p0);
    boolean matches(String p0, int p1);
    static int MATCH_CASE_INSENSITIVE = 0;
    static int MATCH_DEFAULT = 0;
    static int MATCH_MULTILINE = 0;
    static int MATCH_SINGLELINE = 0;
    void setPattern(String p0);
}
