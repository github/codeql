// Generated automatically from org.apache.logging.log4j.util.StringMap for testing purposes

package org.apache.logging.log4j.util;

import org.apache.logging.log4j.util.ReadOnlyStringMap;

public interface StringMap extends ReadOnlyStringMap
{
    boolean equals(Object p0);
    boolean isFrozen();
    int hashCode();
    void clear();
    void freeze();
    void putAll(ReadOnlyStringMap p0);
    void putValue(String p0, Object p1);
    void remove(String p0);
}
