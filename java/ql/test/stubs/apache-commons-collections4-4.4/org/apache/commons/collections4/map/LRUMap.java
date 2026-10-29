// Generated automatically from org.apache.commons.collections4.map.LRUMap for testing purposes

package org.apache.commons.collections4.map;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.Map;
import org.apache.commons.collections4.BoundedMap;
import org.apache.commons.collections4.map.AbstractHashedMap;
import org.apache.commons.collections4.map.AbstractLinkedMap;

public class LRUMap<K, V> extends AbstractLinkedMap<K, V> implements BoundedMap<K, V>, Cloneable, Serializable
{
    protected boolean removeLRU(AbstractLinkedMap.LinkEntry<K, V> p0){ return false; }
    protected static int DEFAULT_MAX_SIZE = 0;
    protected void addMapping(int p0, int p1, K p2, V p3){}
    protected void doReadObject(ObjectInputStream p0){}
    protected void doWriteObject(ObjectOutputStream p0){}
    protected void moveToMRU(AbstractLinkedMap.LinkEntry<K, V> p0){}
    protected void reuseMapping(AbstractLinkedMap.LinkEntry<K, V> p0, int p1, int p2, K p3, V p4){}
    protected void updateEntry(AbstractHashedMap.HashEntry<K, V> p0, V p1){}
    public LRUMap(){}
    public LRUMap(Map<? extends K, ? extends V> p0){}
    public LRUMap(Map<? extends K, ? extends V> p0, boolean p1){}
    public LRUMap(int p0){}
    public LRUMap(int p0, boolean p1){}
    public LRUMap(int p0, float p1){}
    public LRUMap(int p0, float p1, boolean p2){}
    public LRUMap(int p0, int p1){}
    public LRUMap(int p0, int p1, float p2){}
    public LRUMap(int p0, int p1, float p2, boolean p3){}
    public LRUMap<K, V> clone(){ return null; }
    public V get(Object p0){ return null; }
    public V get(Object p0, boolean p1){ return null; }
    public boolean isFull(){ return false; }
    public boolean isScanUntilRemovable(){ return false; }
    public int maxSize(){ return 0; }
}
