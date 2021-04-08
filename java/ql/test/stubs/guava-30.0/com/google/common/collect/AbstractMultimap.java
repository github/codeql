/*
 * Copyright (C) 2012 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.common.collect;

import java.util.Collection;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

abstract class AbstractMultimap<K, V> implements Multimap<K, V> {
  @Override
  public boolean isEmpty() {
    return false;
  }

  @Override
  public boolean containsValue(Object value) {
    return false;
  }

  @Override
  public boolean containsEntry(Object key, Object value) {
    return false;
  }

  @Override
  public boolean remove(Object key, Object value) {
    return false;
  }

  @Override
  public boolean put(K key, V value) {
    return false;
  }

  @Override
  public boolean putAll(K key, Iterable<? extends V> values) {
    return false;
  }

  @Override
  public boolean putAll(Multimap<? extends K, ? extends V> multimap) {
    return false;
  }

  @Override
  public Collection<V> replaceValues(K key, Iterable<? extends V> values) {
    return null;
  }

  @Override
  public Collection<Entry<K, V>> entries() {
    return null;
  }

  @Override
  public Set<K> keySet() {
    return null;
  }

  @Override
  public Multiset<K> keys() {
    return null;
  }

  @Override
  public Collection<V> values() {
    return null;
  }

  @Override
  public Map<K, Collection<V>> asMap() {
    return null;
  }

}
