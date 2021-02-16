/*
 * Copyright (C) 2007 The Guava Authors
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
import java.util.function.BiConsumer;

public interface Multimap<K, V> {
  int size();

  boolean isEmpty();

  boolean containsKey(Object key);

  boolean containsValue(Object value);

  boolean containsEntry(Object key, Object value);

  boolean put(K key, V value);

  boolean remove(Object key, Object value);

  boolean putAll(K key, Iterable<? extends V> values);

  boolean putAll(Multimap<? extends K, ? extends V> multimap);

  Collection<V> replaceValues(K key, Iterable<? extends V> values);

  Collection<V> removeAll(Object key);

  void clear();

  Collection<V> get(K key);

  Set<K> keySet();

  Multiset<K> keys();

  Collection<V> values();

  Collection<Entry<K, V>> entries();

  default void forEach(BiConsumer<? super K, ? super V> action) {
  }

  Map<K, Collection<V>> asMap();
}
