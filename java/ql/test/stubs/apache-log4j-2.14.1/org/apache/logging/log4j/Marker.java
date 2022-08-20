// Generated automatically from org.apache.logging.log4j.Marker for testing purposes

package org.apache.logging.log4j;

import java.io.Serializable;

public interface Marker extends Serializable
{
    Marker addParents(Marker... p0);
    Marker setParents(Marker... p0);
    Marker[] getParents();
    String getName();
    boolean equals(Object p0);
    boolean hasParents();
    boolean isInstanceOf(Marker p0);
    boolean isInstanceOf(String p0);
    boolean remove(Marker p0);
    int hashCode();
}
