// Generated automatically from org.apache.velocity.util.introspection.Uberspect for testing purposes

package org.apache.velocity.util.introspection;

import java.util.Iterator;
import org.apache.velocity.util.introspection.Info;
import org.apache.velocity.util.introspection.VelMethod;
import org.apache.velocity.util.introspection.VelPropertyGet;
import org.apache.velocity.util.introspection.VelPropertySet;

public interface Uberspect
{
    Iterator getIterator(Object p0, Info p1);
    VelMethod getMethod(Object p0, String p1, Object[] p2, Info p3);
    VelPropertyGet getPropertyGet(Object p0, String p1, Info p2);
    VelPropertySet getPropertySet(Object p0, String p1, Object p2, Info p3);
    void init();
}
