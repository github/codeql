// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.util.LRUMap for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.util;

import java.io.Serializable;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.locks.Lock;

public class LRUMap<K, V> extends java.util.LinkedHashMap<K, V> implements Serializable
{
    protected LRUMap() {}
    protected Object readResolve(){ return null; }
    protected boolean removeEldestEntry(Map.Entry<K, V> p0){ return false; }
    protected final Lock _readLock = null;
    protected final Lock _writeLock = null;
    protected final int _maxEntries = 0;
    protected int _jdkSerializeMaxEntries = 0;
    public LRUMap(int p0, int p1){}
    public V get(Object p0){ return null; }
    public V put(K p0, V p1){ return null; }
    public V remove(Object p0){ return null; }
}
