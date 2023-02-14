// Generated automatically from io.netty.util.collection.CharObjectMap for testing purposes

package io.netty.util.collection;

import java.util.Map;

public interface CharObjectMap<V> extends Map<Character, V>
{
    Iterable<CharObjectMap.PrimitiveEntry<V>> entries();
    V get(char p0);
    V put(char p0, V p1);
    V remove(char p0);
    boolean containsKey(char p0);
    static public interface PrimitiveEntry<V>
    {
        V value();
        char key();
        void setValue(V p0);
    }
}
