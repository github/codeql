// Generated automatically from org.apache.logging.log4j.util.IndexedReadOnlyStringMap for testing purposes

package org.apache.logging.log4j.util;

import org.apache.logging.log4j.util.ReadOnlyStringMap;

public interface IndexedReadOnlyStringMap extends ReadOnlyStringMap
{
    <V> V getValueAt(int p0);
    String getKeyAt(int p0);
    int indexOfKey(String p0);
}
