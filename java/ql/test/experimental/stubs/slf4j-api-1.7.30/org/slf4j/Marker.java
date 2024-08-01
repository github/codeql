// Generated automatically from org.slf4j.Marker for testing purposes

package org.slf4j;

import java.io.Serializable;
import java.util.Iterator;

public interface Marker extends Serializable
{
    Iterator<Marker> iterator();
    String getName();
    boolean contains(Marker p0);
    boolean contains(String p0);
    boolean equals(Object p0);
    boolean hasChildren();
    boolean hasReferences();
    boolean remove(Marker p0);
    int hashCode();
    static String ANY_MARKER = null;
    static String ANY_NON_NULL_MARKER = null;
    void add(Marker p0);
}
