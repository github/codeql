/*
 * Copyright (C) 2009 The Guava Authors
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

import java.util.Comparator;
import java.util.Map;
import java.util.SortedMap;

public final class ImmutableSortedMap<K, V> extends ImmutableMap<K, V>{

  public static <K, V> ImmutableSortedMap<K, V> of() {
    return null;
  }

  public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(K k1, V v1) {
    return null;
  }

  public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(
      K k1, V v1, K k2, V v2) {
    return null;
  }

  public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(
      K k1, V v1, K k2, V v2, K k3, V v3) {
    return null;
  }

  public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(
      K k1, V v1, K k2, V v2, K k3, V v3, K k4, V v4) {
    return null;
  }

  public static <K extends Comparable<? super K>, V> ImmutableSortedMap<K, V> of(
      K k1, V v1, K k2, V v2, K k3, V v3, K k4, V v4, K k5, V v5) {
    return null;
  }

  public static <K, V> ImmutableSortedMap<K, V> copyOf(Map<? extends K, ? extends V> map) {
    return null;
  }

  public static <K, V> ImmutableSortedMap<K, V> copyOf(
      Map<? extends K, ? extends V> map, Comparator<? super K> comparator) {
    return null;
  }

  public static <K, V> ImmutableSortedMap<K, V> copyOf(
      Iterable<? extends Entry<? extends K, ? extends V>> entries) {
    return null;
  }

  public static <K, V> ImmutableSortedMap<K, V> copyOf(
      Iterable<? extends Entry<? extends K, ? extends V>> entries,
      Comparator<? super K> comparator) {
    return null;
  }

  public static <K, V> ImmutableSortedMap<K, V> copyOfSorted(SortedMap<K, ? extends V> map) {
    return null;
  }

  @Override
  public V get(Object key) {
    return null;
  }

  @Override
  public int size() {
    return 0;
  }

  public static <K extends Comparable<?>, V> Builder<K, V> naturalOrder() {
    return null;
  }

  public static <K, V> Builder<K, V> orderedBy(Comparator<K> comparator) {
    return null;
  }

  public static <K extends Comparable<?>, V> Builder<K, V> reverseOrder() {
    return null;
  }

  public static class Builder<K, V> extends ImmutableMap.Builder<K, V> {
    public Builder(Comparator<? super K> comparator) {
    }

  }

}
