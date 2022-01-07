// Generated automatically from com.google.common.cache.RemovalNotification for testing purposes, and adjusted manually

package com.google.common.cache;

import com.google.common.cache.RemovalCause;
import java.util.AbstractMap;

public class RemovalNotification<K, V> extends AbstractMap.SimpleImmutableEntry<K, V>
{
    protected RemovalNotification(K k, V v) { super(k,v); }
    public RemovalCause getCause(){ return null; }
    public boolean wasEvicted(){ return false; }
    public static <K, V> RemovalNotification<K, V> create(K p0, V p1, RemovalCause p2){ return null; }
}
