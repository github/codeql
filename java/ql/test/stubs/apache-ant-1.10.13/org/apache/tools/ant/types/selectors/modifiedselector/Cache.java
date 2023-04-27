// Generated automatically from org.apache.tools.ant.types.selectors.modifiedselector.Cache for testing purposes

package org.apache.tools.ant.types.selectors.modifiedselector;

import java.util.Iterator;

public interface Cache
{
    Iterator<String> iterator();
    Object get(Object p0);
    boolean isValid();
    void delete();
    void load();
    void put(Object p0, Object p1);
    void save();
}
