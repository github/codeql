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

import java.util.AbstractSet;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.NavigableSet;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.function.Predicate;

public final class Sets {
  private Sets() {}

  public static <E> HashSet<E> newHashSet() {
    return null;
  }

  public static <E> HashSet<E> newHashSet(E... elements) {
    return null;
  }

  public static <E> HashSet<E> newHashSet(Iterable<? extends E> elements) {
    return null;
  }
  public abstract static class SetView<E> extends AbstractSet<E> {
    private SetView() {} 
  }

  public static <E> SetView<E> union(final Set<? extends E> set1, final Set<? extends E> set2) {
    return null;
  }

  public static <E> SetView<E> intersection(final Set<E> set1, final Set<?> set2) {
    return null;
  }

  public static <E> SetView<E> difference(final Set<E> set1, final Set<?> set2) {
    return null;
  }

  public static <E> SetView<E> symmetricDifference(
      final Set<? extends E> set1, final Set<? extends E> set2) {
    return null;
  }

  public static <E> Set<E> filter(Set<E> unfiltered, Predicate<? super E> predicate) {
    return null;
  }

  
  public static <B> Set<List<B>> cartesianProduct(List<? extends Set<? extends B>> sets) {
    return null;
  }

  public static <B> Set<List<B>> cartesianProduct(Set<? extends B>... sets) {
    return null;
  }

  public static <E> Set<Set<E>> powerSet(Set<E> set) {
    return null;
  }

  public static <E> Set<Set<E>> combinations(Set<E> set, final int size) {
    return null;
  }

  public static <E> NavigableSet<E> synchronizedNavigableSet(NavigableSet<E> navigableSet) {
    return null;
  }

  public static <K extends Comparable<? super K>> NavigableSet<K> subSet(
      NavigableSet<K> set, Object range) {
    return null;
  }
}
