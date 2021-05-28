/*
 * Copyright (C) 2008 The Guava Authors
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
import java.util.Comparator;
import java.util.Map;
import java.util.Map.Entry;

public abstract class ImmutableMultimap<K, V> extends AbstractMultimap<K, V> {
  public static <K, V> ImmutableMultimap<K, V> of() {
    return null;
  }

  public static <K, V> ImmutableMultimap<K, V> of(K k1, V v1) {
    return null;
  }

  public static <K, V> ImmutableMultimap<K, V> of(K k1, V v1, K k2, V v2) {
    return null;
  }

  public static <K, V> ImmutableMultimap<K, V> of(K k1, V v1, K k2, V v2, K k3, V v3) {
    return null;
  }

  public static <K, V> ImmutableMultimap<K, V> of(K k1, V v1, K k2, V v2, K k3, V v3, K k4, V v4) {
    return null;
  }

  public static <K, V> ImmutableMultimap<K, V> of(
      K k1, V v1, K k2, V v2, K k3, V v3, K k4, V v4, K k5, V v5) {
    return null;
  }

  public static <K, V> Builder<K, V> builder() {
    return null;
  }

  public static class Builder<K, V> {
    public Builder() {
    }

    public Builder<K, V> put(K key, V value) {
      return null;
    }

    public Builder<K, V> put(Entry<? extends K, ? extends V> entry) {
      return null;
    }

    public Builder<K, V> putAll(Iterable<? extends Entry<? extends K, ? extends V>> entries) {
      return null;
    }

    public Builder<K, V> putAll(K key, Iterable<? extends V> values) {
      return null;
    }

    public Builder<K, V> putAll(K key, V... values) {
      return null;
    }

    public Builder<K, V> putAll(Multimap<? extends K, ? extends V> multimap) {
      return null;
    }

    public Builder<K, V> orderKeysBy(Comparator<? super K> keyComparator) {
      return null;
    }

    public Builder<K, V> orderValuesBy(Comparator<? super V> valueComparator) {
      return null;
    }

    public ImmutableMultimap<K, V> build() {
      return null;
    }

  }
  public static <K, V> ImmutableMultimap<K, V> copyOf(Multimap<? extends K, ? extends V> multimap) {
    return null;
  }

  public static <K, V> ImmutableMultimap<K, V> copyOf(
      Iterable<? extends Entry<? extends K, ? extends V>> entries) {
    return null;
  }

  @Override
  public ImmutableCollection<V> removeAll(Object key) {
    return null;
  }

  @Override
  public void clear() {
  }

  @Override
  public abstract ImmutableCollection<V> get(K key);

  public abstract ImmutableMultimap<V, K> inverse();

  @Override
  public boolean containsKey(Object key) {
    return false;
  }

  @Override
  public int size() {
    return 0;
  }

}
