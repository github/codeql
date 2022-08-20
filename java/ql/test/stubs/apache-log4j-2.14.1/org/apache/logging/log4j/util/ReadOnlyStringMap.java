// Generated automatically from org.apache.logging.log4j.util.ReadOnlyStringMap for testing purposes

package org.apache.logging.log4j.util;

import java.io.Serializable;
import java.util.Map;
import org.apache.logging.log4j.util.BiConsumer;
import org.apache.logging.log4j.util.TriConsumer;

public interface ReadOnlyStringMap extends Serializable
{
    <V, S> void forEach(TriConsumer<String, ? super V, S> p0, S p1);
    <V> V getValue(String p0);
    <V> void forEach(BiConsumer<String, ? super V> p0);
    Map<String, String> toMap();
    boolean containsKey(String p0);
    boolean isEmpty();
    int size();
}
