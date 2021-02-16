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
import java.util.Iterator;
import java.util.NavigableSet;
import java.util.SortedSet;

public abstract class ImmutableSortedSet<E> extends ImmutableSet<E>
    implements NavigableSet<E> {
  
  public static <E> ImmutableSortedSet<E> of() {
    return null;
  }

  public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E element) {
    return null;
  }

  public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E e1, E e2) {
    return null;
  }

  public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E e1, E e2, E e3) {
    return null;
  }

  public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(E e1, E e2, E e3, E e4) {
    return null;
  }

  public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(
      E e1, E e2, E e3, E e4, E e5) {
    return null;
  }

  public static <E extends Comparable<? super E>> ImmutableSortedSet<E> of(
      E e1, E e2, E e3, E e4, E e5, E e6, E... remaining) {
    return null;
  }

  public static <E extends Comparable<? super E>> ImmutableSortedSet<E> copyOf(E[] elements) {
    return null;
  }

  public static <E> ImmutableSortedSet<E> copyOf(Iterable<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableSortedSet<E> copyOf(Collection<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableSortedSet<E> copyOf(Iterator<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableSortedSet<E> copyOf(
      Comparator<? super E> comparator, Iterator<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableSortedSet<E> copyOf(
      Comparator<? super E> comparator, Iterable<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableSortedSet<E> copyOf(
      Comparator<? super E> comparator, Collection<? extends E> elements) {
    return null;
  }

  public static <E> ImmutableSortedSet<E> copyOfSorted(SortedSet<E> sortedSet) {
    return null;
  }

  public static <E> Builder<E> orderedBy(Comparator<E> comparator) {
    return null;
  }

  public static <E extends Comparable<?>> Builder<E> reverseOrder() {
    return null;
  }

  public static <E extends Comparable<?>> Builder<E> naturalOrder() {
    return null;
  }

  public static final class Builder<E> extends ImmutableSet.Builder<E> {
    public Builder(Comparator<? super E> comparator) {
    }

  }

}
