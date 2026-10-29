// Generated automatically from org.dom4j.rule.Pattern for testing purposes

package org.dom4j.rule;

import org.dom4j.Node;
import org.dom4j.NodeFilter;

public interface Pattern extends NodeFilter
{
    Pattern[] getUnionPatterns();
    String getMatchesNodeName();
    boolean matches(Node p0);
    double getPriority();
    short getMatchType();
    static double DEFAULT_PRIORITY = 0;
    static short ANY_NODE = 0;
    static short NONE = 0;
    static short NUMBER_OF_TYPES = 0;
}
