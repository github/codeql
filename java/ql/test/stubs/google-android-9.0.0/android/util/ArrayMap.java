/*
 * Copyright (C) 2013 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package android.util;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

public final class ArrayMap<K, V> implements Map<K, V> {
    public static final ArrayMap EMPTY = new ArrayMap<>(-1);

    public ArrayMap() {}

    public ArrayMap(int capacity) {}

    public ArrayMap(int capacity, boolean identityHashCode) {}

    public ArrayMap(ArrayMap<K, V> map) {}

    @Override
    public void clear() {}

    public void erase() {}

    public void ensureCapacity(int minimumCapacity) {}

    @Override
    public boolean containsKey(Object key) {
        return false;
    }

    public int indexOfKey(Object key) {
        return 0;
    }

    public int indexOfValue(Object value) {
        return 0;
    }

    @Override
    public boolean containsValue(Object value) {
        return false;
    }

    @Override
    public V get(Object key) {
        return null;
    }

    public K keyAt(int index) {
        return null;
    }

    public V valueAt(int index) {
        return null;
    }

    public V setValueAt(int index, V value) {
        return null;
    }

    @Override
    public boolean isEmpty() {
        return false;
    }

    @Override
    public V put(K key, V value) {
        return null;
    }

    public void append(K key, V value) {}

    public void validate() {}

    public void putAll(ArrayMap<? extends K, ? extends V> array) {}

    @Override
    public V remove(Object key) {
        return null;
    }

    public V removeAt(int index) {
        return null;
    }

    @Override
    public int size() {
        return 0;
    }

    @Override
    public boolean equals(Object object) {
        return false;
    }

    @Override
    public int hashCode() {
        return 0;
    }

    @Override
    public String toString() {
        return null;
    }

    public boolean containsAll(Collection<?> collection) {
        return false;
    }

    @Override
    public void putAll(Map<? extends K, ? extends V> map) {}

    public boolean removeAll(Collection<?> collection) {
        return false;
    }

    public boolean retainAll(Collection<?> collection) {
        return false;
    }

    @Override
    public Set<Map.Entry<K, V>> entrySet() {
        return null;
    }

    @Override
    public Set<K> keySet() {
        return null;
    }

    @Override
    public Collection<V> values() {
        return null;
    }

}
