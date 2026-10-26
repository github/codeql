// Generated automatically from org.apache.commons.collections4.MapIterator for testing purposes

package org.apache.commons.collections4;

import java.util.Iterator;

public interface MapIterator<K, V> extends Iterator<K>
{
    K getKey();
    K next();
    V getValue();
    V setValue(V p0);
    boolean hasNext();
    void remove();
}
